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

    var buttonTitle: String {
        switch phase {
        case .ready: "준비..."
        case .running: "연타!!!"
        case .finished: "완주!"
        }
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

    /// 진행 중에만 탭을 셈. 완주시킨 탭이면 완주 기록을, 그 외에는 nil을 반환함.
    func tap(at date: Date = .now) -> TimeInterval? {
        guard case .running(let startDate) = phase else { return nil }

        tapCount += 1
        guard tapCount >= requiredTapCount else { return nil }

        let record = date.timeIntervalSince(startDate)
        phase = .finished(record: record)
        return record
    }

}
