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

    enum ResultState {
        case idle
        case submitting
        case waiting
        case failed
        case completed
    }

    private static let measurementSeconds = 10

    private(set) var state = State.ready
    private(set) var currentDecibel = 0.0
    private(set) var highestDecibel = 0.0
    private(set) var remainingSeconds = SoundTugViewModel.measurementSeconds
    private(set) var errorMessage: String?
    private(set) var result: SoundTugResult?
    private(set) var resultState = ResultState.idle
    private(set) var resultErrorMessage: String?

    private let meter = SoundLevelMeter()
    private var measurementTask: Task<Void, Never>?
    private var runID: UUID?
    private var lastScoreUpdate: ContinuousClock.Instant?
    private let service: BaseService
    private var resultTask: Task<Void, Never>?
    private var resultRequestID: UUID?
    private var hasAttemptedSubmission = false
    private var hasSubmittedRecord = false

    init(service: BaseService = .shared) {
        self.service = service
    }

    var isRunning: Bool {
        state == .preparing || state == .measuring
    }

    var isLoadingResult: Bool {
        resultState == .submitting || resultState == .waiting
    }

    var resultMessage: String? {
        switch resultState {
        case .idle: "결과 조회를 준비하고 있어요."
        case .submitting: "내 기록을 제출하고 있어요."
        case .waiting: "다른 참가자의 기록을 기다리고 있어요."
        case .failed: resultErrorMessage
        case .completed: nil
        }
    }

    func start() {
        guard !isRunning, state != .finished else { return }
        currentDecibel = 0
        highestDecibel = 0
        lastScoreUpdate = nil
        remainingSeconds = Self.measurementSeconds
        errorMessage = nil
        state = .preparing
        let runID = UUID()
        self.runID = runID

        measurementTask = Task { [weak self] in
            await self?.measure(runID: runID)
        }
    }

    func cancel() {
        resultRequestID = nil
        resultTask?.cancel()
        resultTask = nil
        if isLoadingResult { resultState = .idle }
        guard isRunning else { return }
        finish(state: .ready)
    }

    func loadResult() {
        guard state == .finished, result == nil, resultTask == nil else { return }
        let requestID = UUID()
        resultRequestID = requestID
        resultErrorMessage = nil
        resultState = hasSubmittedRecord ? .waiting : .submitting
        resultTask = Task { [weak self] in
            await self?.submitAndFetchResult(requestID: requestID)
        }
    }

    private func measure(runID: UUID) async {
        do {
            try await meter.start { [weak self] result in
                guard let self, self.runID == runID else { return }
                switch result {
                case .success(let decibel):
                    self.updateDecibel(decibel)
                case .failure(let error):
                    self.finish(state: .failed, error: error)
                }
            }
            try Task.checkCancellation()
            guard self.runID == runID else { return }
            state = .measuring

            let clock = ContinuousClock()
            let deadline = clock.now.advanced(by: .seconds(Self.measurementSeconds))
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

    private func updateDecibel(_ decibel: Double) {
        highestDecibel = max(highestDecibel, decibel)

        let now = ContinuousClock.now
        defer { lastScoreUpdate = now }
        guard let lastScoreUpdate else {
            currentDecibel = decibel
            return
        }

        let duration = lastScoreUpdate.duration(to: now)
        let elapsed = Double(duration.components.seconds)
            + Double(duration.components.attoseconds) / 1e18
        let responseTime = decibel > currentDecibel ? 0.12 : 0.25
        let weight = 1 - exp(-max(0, elapsed) / responseTime)
        currentDecibel += (decibel - currentDecibel) * weight
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
        if self.state == .finished { loadResult() }
    }

}

private extension SoundTugViewModel {

    func submitAndFetchResult(requestID: UUID) async {
        defer {
            if resultRequestID == requestID {
                resultTask = nil
                resultRequestID = nil
            }
        }
        do {
            let context = try SoundTugMatchContext.load()
            if !hasSubmittedRecord {
                if hasAttemptedSubmission {
                    // 이전 응답을 못 받았어도 서버에서 경기가 끝났을 수 있음.
                    do {
                        let result = try await fetchResult(context: context)
                        try Task.checkCancellation()
                        guard resultRequestID == requestID else { return }
                        self.result = result
                        hasSubmittedRecord = true
                        resultState = .completed
                        return
                    } catch {
                        guard isResultPending(error) else { throw error }
                    }
                }
                hasAttemptedSubmission = true
                do {
                    let response: SoundTugRecordResponseDTO = try await service.request(
                        endPoint: .submitVoiceRecord(
                            matchID: context.matchID, memberID: context.memberID
                        ),
                        body: SoundTugRecordRequestDTO(maxDecibel: highestDecibel)
                    )
                    try response.validate(context: context)
                    try Task.checkCancellation()
                    guard resultRequestID == requestID else { return }
                    hasSubmittedRecord = true
                } catch {
                    try Task.checkCancellation()
                    hasAttemptedSubmission = isSubmissionUncertain(error)
                    guard hasAttemptedSubmission else { throw error }
                    // 제출 중 경기 종료로 요청이 거절된 경우에도 확정 결과는 조회함.
                    if let result = try? await fetchResult(context: context) {
                        try Task.checkCancellation()
                        guard resultRequestID == requestID else { return }
                        self.result = result
                        hasSubmittedRecord = true
                        resultState = .completed
                        return
                    }
                    throw error
                }
            }
            try Task.checkCancellation()
            guard resultRequestID == requestID else { return }
            resultState = .waiting
            let result = try await waitForResult(context: context)
            try Task.checkCancellation()
            guard resultRequestID == requestID else { return }
            self.result = result
            resultState = .completed
        } catch {
            guard resultRequestID == requestID else { return }
            if error is CancellationError || Task.isCancelled {
                resultState = .idle
            } else {
                resultState = .failed
                resultErrorMessage = (error as? SoundTugAPIError)?.localizedDescription
                    ?? "기록 처리에 실패했어요. 연결을 확인하고 다시 시도해 주세요."
            }
        }
    }

    func fetchResult(context: SoundTugMatchContext) async throws -> SoundTugResult {
        let response: SoundTugResultResponseDTO = try await service.request(
            endPoint: .voiceResult(matchID: context.matchID)
        )
        try Task.checkCancellation()
        return try response.toResult(context: context)
    }

    func waitForResult(context: SoundTugMatchContext) async throws -> SoundTugResult {
        try await withThrowingTaskGroup(of: SoundTugResult.self) { group in
            group.addTask { @MainActor in
                while true {
                    try Task.checkCancellation()
                    do {
                        return try await self.fetchResult(context: context)
                    } catch {
                        guard self.isResultPending(error) else { throw error }
                    }
                    try await Task.sleep(for: .seconds(1))
                }
            }
            group.addTask {
                try await Task.sleep(for: .seconds(30))
                throw SoundTugAPIError.resultTimedOut
            }
            defer { group.cancelAll() }
            guard let result = try await group.next() else { throw CancellationError() }
            return result
        }
    }

    func isResultPending(_ error: Error) -> Bool {
        if case SoundTugAPIError.resultPending = error { return true }
        return (error as? NetworkError)?.serverCode == "GAME_RECORDS_NOT_COMPLETE"
    }

    func isSubmissionUncertain(_ error: Error) -> Bool {
        guard let error = error as? NetworkError else { return false }
        switch error {
        case .transportError, .responseDecodingError, .noData:
            return true
        case .httpError(let status, _):
            return status == 409 || status >= 500
        default:
            return false
        }
    }

}
