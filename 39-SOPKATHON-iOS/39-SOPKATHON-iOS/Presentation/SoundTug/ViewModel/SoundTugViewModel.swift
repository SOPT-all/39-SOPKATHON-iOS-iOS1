//
//  SoundTugViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import Foundation
import Observation

@Observable
final class SoundTugViewModel {

    enum State {
        case ready
        case preparing
        case measuring
        case finished
        case failed
    }

    private(set) var state = State.ready
    private(set) var currentScore = 0.0
    private(set) var highestScore = 0.0
    private(set) var remainingSeconds = 10
    private(set) var errorMessage: String?

    private let meter = SoundLevelMeter()
    private var measurementTask: Task<Void, Never>?
    private var runID: UUID?
    private var lastScoreUpdate: ContinuousClock.Instant?
    private var isAboveNoiseFloor = false

    var isRunning: Bool {
        state == .preparing || state == .measuring
    }

    var buttonTitle: String {
        switch state {
        case .ready: return "음량 측정 시작"
        case .preparing: return "마이크 준비 중 · 취소"
        case .measuring: return "소리를 질러주세요! · 중지"
        case .finished, .failed: return "다시 측정하기"
        }
    }

    func start() {
        guard !isRunning else { return }
        currentScore = 0
        highestScore = 0
        lastScoreUpdate = nil
        isAboveNoiseFloor = false
        remainingSeconds = 10
        errorMessage = nil
        state = .preparing
        let runID = UUID()
        self.runID = runID

        measurementTask = Task { [weak self] in
            await self?.measure(runID: runID)
        }
    }

    func cancel() {
        guard isRunning else { return }
        finish(state: .ready)
    }

    private func measure(runID: UUID) async {
        do {
            try await meter.start { [weak self] result in
                guard let self, self.runID == runID else { return }
                switch result {
                case .success(let score):
                    self.updateScore(score)
                case .failure(let error):
                    self.finish(state: .failed, error: error)
                }
            }
            try Task.checkCancellation()
            guard self.runID == runID else { return }
            state = .measuring

            let clock = ContinuousClock()
            let deadline = clock.now.advanced(by: .seconds(10))
            while clock.now < deadline {
                let duration = clock.now.duration(to: deadline)
                let seconds = Double(duration.components.seconds)
                    + Double(duration.components.attoseconds) / 1e18
                remainingSeconds = max(0, Int(ceil(seconds)))
                try await Task.sleep(for: .milliseconds(50))
                guard self.runID == runID else { return }
            }
            remainingSeconds = 0
            finish(state: .finished)
        } catch {
            guard self.runID == runID else { return }
            finish(state: error is CancellationError ? .ready : .failed, error: error)
        }
    }

    private func updateScore(_ score: Double) {
        // 조용한 환경의 25~35점 입력을 차단하고 경계에서 반복 전환을 줄임.
        if score >= 38 {
            isAboveNoiseFloor = true
        } else if score <= 35 {
            isAboveNoiseFloor = false
        }
        let filteredScore = isAboveNoiseFloor ? score : 0
        highestScore = max(highestScore, filteredScore)

        let now = ContinuousClock.now
        defer { lastScoreUpdate = now }
        guard let lastScoreUpdate else {
            currentScore = filteredScore
            return
        }

        let duration = lastScoreUpdate.duration(to: now)
        let elapsed = Double(duration.components.seconds)
            + Double(duration.components.attoseconds) / 1e18
        let responseTime = filteredScore > currentScore ? 0.12 : 0.25
        let weight = 1 - exp(-max(0, elapsed) / responseTime)
        currentScore += (filteredScore - currentScore) * weight
    }

    private func finish(state: State, error: Error? = nil) {
        runID = nil
        measurementTask?.cancel()
        measurementTask = nil
        self.state = state
        errorMessage = error?.localizedDescription
        do {
            try meter.stop()
        } catch {
            self.state = .failed
            errorMessage = error.localizedDescription
        }
    }

}
