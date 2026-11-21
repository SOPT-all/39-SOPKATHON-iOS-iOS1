//
//  HorseRaceViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import Foundation

@Observable
final class HorseRaceViewModel {

    // 탭당 약 30pt 기준. 트랙이 흐르는 거리(Figma 기준 약 1,770pt) ÷ 30.
    // 트랙 길이를 바꾸면 함께 조정 필요.
    private let trackTapCount = 59
    // 배경이 끝난 뒤 달리는 사람이 화면 폭(약 375pt)만큼 나가는 데 필요한 탭 수. 375 ÷ 30.
    private let runnerExitTapCount = 13
    // TODO: 서버 시작 신호 사용 여부 확정 후 카운트다운 대체 검토 필요.
    private let countdown: Duration = .seconds(3)
    // 서버 명세의 경기 종료 상태 조회 간격과 같게 둠.
    private let resultCheckInterval: Duration = .seconds(3)

    private let match: HorseRaceMatch?
    private let service: BaseService

    private(set) var phase: HorseRacePhase = .ready
    private(set) var tapCount = 0

    init(match: HorseRaceMatch?, service: BaseService = .shared) {
        self.match = match
        self.service = service
    }

    private var requiredTapCount: Int {
        trackTapCount + runnerExitTapCount
    }

    /// 배경 트랙 진행률(0...1). 트랙 끝에 닿으면 1로 멈춤.
    var trackProgress: Double {
        min(Double(tapCount) / Double(trackTapCount), 1)
    }

    /// 트랙 끝에 닿은 뒤 달리는 사람이 화면 밖으로 나가는 진행률(0...1).
    var runnerProgress: Double {
        let runnerTapCount = max(tapCount - trackTapCount, 0)
        return min(Double(runnerTapCount) / Double(runnerExitTapCount), 1)
    }

    /// 탭할 때마다 달리기 자세를 번갈아 바꿈. 탭 수가 홀수면 두 번째 자세.
    var isSecondRunnerPose: Bool {
        !tapCount.isMultiple(of: 2)
    }

    var isReady: Bool {
        phase == .ready
    }

    /// 완주 후 경기 완료 여부를 확인하는 중인지 여부.
    var isWaitingForResult: Bool {
        if case .finished = phase { true } else { false }
    }

    /// 완주 이후(완료 확인 중·결과 표시·비정상 종료) 화면을 어둡게 덮을지 여부.
    var isGameOver: Bool {
        switch phase {
        case .ready, .running: false
        case .finished, .completed, .aborted: true
        }
    }

    var isAborted: Bool {
        phase == .aborted
    }

    var result: HorseRaceResult? {
        if case .completed(let result) = phase { result } else { nil }
    }

    var buttonTitle: String {
        isReady ? "준비..." : "연타!!!"
    }

    /// 준비 단계에서 카운트다운이 끝나면 경기를 시작함. 대기 중 취소되면 시작하지 않음.
    func startAfterCountdown() async {
        guard isReady else { return }
        do {
            try await Task.sleep(for: countdown)
        } catch {
            // 화면 이탈로 task가 취소된 경우라 시작하지 않고 종료함.
            return
        }
        guard isReady else { return }
        phase = .running(startDate: .now)
    }

    /// 진행 중에만 탭을 셈. 필요한 탭 수를 채우면 완주 기록과 함께 완주 상태로 바꿈.
    func tap(at date: Date = .now) {
        guard case .running(let startDate) = phase else { return }

        tapCount += 1
        guard tapCount >= requiredTapCount else { return }

        phase = .finished(record: date.timeIntervalSince(startDate))
    }

    /// 완주 기록을 제출한 뒤 경기 종료 상태를 일정 간격으로 확인해 결과나 비정상 종료로 바꿈.
    /// 요청 실패는 다음 간격에 다시 시도하고, 화면 이탈로 취소되면 멈춤.
    func waitForResult() async {
        guard case .finished(let record) = phase else { return }
        guard let match else {
            phase = .aborted
            return
        }

        let elapsedMilliseconds = Int64((record * 1000).rounded())
        var isRecordSubmitted = false
        while isWaitingForResult {
            do {
                // 서버가 이미 제출한 기록은 바꾸지 않아 화면 재진입으로 다시 보내도 안전함.
                if !isRecordSubmitted {
                    try await submitRecord(elapsedMilliseconds, match: match)
                    isRecordSubmitted = true
                }
                if let nextPhase = try await fetchPhaseAfterFinish(match: match) {
                    phase = nextPhase
                    return
                }
            } catch is CancellationError {
                return
            } catch {
                // 제출·조회 실패는 경기 미완료와 같게 보고 다음 간격에 다시 시도함.
            }

            do {
                try await Task.sleep(for: resultCheckInterval)
            } catch {
                // 화면 이탈로 task가 취소된 경우라 확인을 멈춤.
                return
            }
        }
    }

    private func submitRecord(_ elapsedMilliseconds: Int64, match: HorseRaceMatch) async throws {
        let _: HorseRecordSubmitResponseDTO = try await service.request(
            endPoint: .submitHorseRecord(matchID: match.matchID, memberID: match.memberID),
            body: HorseRecordSubmitRequestDTO(elapsedMilliseconds: elapsedMilliseconds)
        )
    }

    /// 경기가 아직 진행 중이면 nil을 반환함.
    private func fetchPhaseAfterFinish(match: HorseRaceMatch) async throws -> HorseRacePhase? {
        let statusResponse: MatchStatusResponseDTO = try await service.request(
            endPoint: .matchStatus(matchID: match.matchID, memberID: match.memberID)
        )
        switch statusResponse.status {
        case .searching, .found, .inProgress:
            return nil
        case .timeout, .cancelled, .invalid:
            return .aborted
        case .finished:
            let resultResponse: MatchResultResponseDTO = try await service.request(
                endPoint: .matchResult(matchID: match.matchID, memberID: match.memberID)
            )
            // 팀 정보가 비어 있으면 결과 확정 전으로 보고 다음 간격에 다시 조회함.
            guard
                let result = HorseRaceResult(response: resultResponse, myTeamSlot: match.teamSlot)
            else {
                return nil
            }
            return .completed(result)
        }
    }

}
