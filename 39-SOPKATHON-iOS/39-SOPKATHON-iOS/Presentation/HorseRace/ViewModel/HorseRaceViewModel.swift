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
    private let resultCheckInterval: Duration = .seconds(2)

    private(set) var phase: HorseRacePhase = .ready
    private(set) var tapCount = 0

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

    var isReady: Bool {
        phase == .ready
    }

    /// 완주 후 경기 완료 여부를 확인하는 중인지 여부.
    var isWaitingForResult: Bool {
        if case .finished = phase { true } else { false }
    }

    /// 완주 이후(완료 확인 중·결과 표시) 화면을 어둡게 덮을지 여부.
    var isGameOver: Bool {
        switch phase {
        case .ready, .running: false
        case .finished, .completed: true
        }
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

    /// 완주 후 경기 완료가 확인될 때까지 일정 간격으로 확인함. 화면 이탈로 취소되면 멈춤.
    func waitForResult() async {
        while case .finished(let record) = phase {
            do {
                if let result = try await fetchResult(record: record) {
                    phase = .completed(result)
                    return
                }
            } catch is CancellationError {
                return
            } catch {
                // 요청 실패도 미완료와 같게 보고 다음 간격에 다시 확인함.
            }

            do {
                try await Task.sleep(for: resultCheckInterval)
            } catch {
                // 화면 이탈로 task가 취소된 경우라 확인을 멈춤.
                return
            }
        }
    }

    // TODO: 서버 명세 확정 후 BaseService 호출로 교체 필요. 경기 미완료면 nil 반환.
    // 지금은 내 기록을 우리 팀 평균으로 두고 나머지는 Figma 예시 값으로 바로 완료 처리함.
    private func fetchResult(record: TimeInterval) async throws -> HorseRaceResult? {
        let myTeamFinishTimeMilliseconds = Int64((record * 1000).rounded())
        let opponentTeamFinishTimeMilliseconds: Int64 = 13_370
        let isWin = myTeamFinishTimeMilliseconds < opponentTeamFinishTimeMilliseconds
        return HorseRaceResult(
            mySchool: "솝트고등학교 1학년 1반",
            opponentSchool: "부디고등학교 1학년 1반",
            myTeamFinishTimeMilliseconds: myTeamFinishTimeMilliseconds,
            opponentTeamFinishTimeMilliseconds: opponentTeamFinishTimeMilliseconds,
            score: isWin ? 300 : nil
        )
    }

}
