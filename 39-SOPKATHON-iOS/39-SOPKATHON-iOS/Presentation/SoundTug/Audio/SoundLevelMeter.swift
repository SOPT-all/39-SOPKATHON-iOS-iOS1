//
//  SoundLevelMeter.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import AVFoundation

final class SoundLevelMeter {

    private var engine = AVAudioEngine()
    private let session = AVAudioSession.sharedInstance()
    private var measurementID: UUID?
    private var hasInstalledTap = false
    private var isSessionActive = false
    private var audioObservers: [NSObjectProtocol] = []
    private var onUpdate: (@MainActor (Result<Double, Error>) -> Void)?

    private(set) var isMeasuring = false

    func start(onUpdate: @escaping @MainActor (Result<Double, Error>) -> Void) async throws {
        guard measurementID == nil else { throw SoundLevelMeterError.alreadyStarted }

        let measurementID = UUID()
        self.measurementID = measurementID

        do {
            let isGranted = await AVAudioApplication.requestRecordPermission()
            try Task.checkCancellation()
            guard self.measurementID == measurementID else { throw CancellationError() }
            guard isGranted else { throw SoundLevelMeterError.permissionDenied }

            try session.setCategory(.record, mode: .measurement)
            try session.setActive(true)
            isSessionActive = true

            engine = AVAudioEngine()
            let input = engine.inputNode
            let format = input.outputFormat(forBus: 0)
            guard format.sampleRate > 0, format.channelCount > 0 else {
                throw SoundLevelMeterError.inputUnavailable
            }

            self.onUpdate = onUpdate
            input.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: format
            ) { @Sendable [weak self]
                buffer,
                _ in
                let score = Self.calculateScore(buffer: buffer)
                Task { @MainActor [weak self] in
                    guard let self,
                          self.measurementID == measurementID,
                          self.isMeasuring else { return }
                    self.onUpdate?(.success(score))
                }
            }
            hasInstalledTap = true
            engine.prepare()
            try engine.start()
            isMeasuring = true
            observeAudioChanges(measurementID: measurementID)
        } catch {
            if self.measurementID == measurementID {
                try stop()
            }
            throw error
        }
    }

    func stop() throws {
        measurementID = nil
        isMeasuring = false
        onUpdate = nil

        for observer in audioObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        audioObservers.removeAll()
        engine.stop()
        if hasInstalledTap {
            engine.inputNode.removeTap(onBus: 0)
            hasInstalledTap = false
        }
        if isSessionActive {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            isSessionActive = false
        }
    }

    private func observeAudioChanges(measurementID: UUID) {
        let interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: nil
        ) { [weak self] notification in
            guard let value = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
                  AVAudioSession.InterruptionType(rawValue: value) == .began else { return }

            Task { @MainActor [weak self] in
                self?.handleAudioFailure(.interrupted, measurementID: measurementID)
            }
        }
        audioObservers.append(interruptionObserver)
        observeFailureNotification(
            .AVAudioEngineConfigurationChange,
            object: engine,
            error: .inputChanged,
            measurementID: measurementID
        )
        observeFailureNotification(
            AVAudioSession.mediaServicesWereResetNotification,
            object: session,
            error: .mediaServicesReset,
            measurementID: measurementID
        )
    }

    private func observeFailureNotification(
        _ name: Notification.Name,
        object: AnyObject,
        error: SoundLevelMeterError,
        measurementID: UUID
    ) {
        let observer = NotificationCenter.default.addObserver(
            forName: name,
            object: object,
            queue: nil
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.handleAudioFailure(error, measurementID: measurementID)
            }
        }
        audioObservers.append(observer)
    }

    private func handleAudioFailure(
        _ error: SoundLevelMeterError,
        measurementID: UUID
    ) {
        guard self.measurementID == measurementID else { return }
        let onUpdate = onUpdate
        defer { engine = AVAudioEngine() }
        do {
            try stop()
            onUpdate?(.failure(error))
        } catch {
            onUpdate?(.failure(error))
        }
    }

    nonisolated private static func calculateScore(buffer: AVAudioPCMBuffer) -> Double {
        guard let channels = buffer.floatChannelData,
              buffer.frameLength > 0,
              buffer.format.channelCount > 0 else { return 0 }

        var sumOfSquares = 0.0
        for channel in 0..<Int(buffer.format.channelCount) {
            for frame in 0..<Int(buffer.frameLength) {
                let sample = Double(channels[channel][frame])
                sumOfSquares += sample * sample
            }
        }
        let sampleCount = Double(buffer.frameLength) * Double(buffer.format.channelCount)
        return SoundLevelScore.calculate(rootMeanSquare: sqrt(sumOfSquares / sampleCount))
    }

}

enum SoundLevelMeterError: Error {

    case alreadyStarted
    case permissionDenied
    case inputUnavailable
    case interrupted
    case inputChanged
    case mediaServicesReset

}

extension SoundLevelMeterError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .alreadyStarted:
            return "이미 음량 측정을 시작했어요."
        case .permissionDenied:
            return "마이크 접근 권한이 필요해요. 설정에서 허용해 주세요."
        case .inputUnavailable:
            return "마이크 입력을 사용할 수 없어요."
        case .interrupted:
            return "마이크 사용이 중단됐어요."
        case .inputChanged:
            return "오디오 장치가 변경됐어요. 다시 측정해 주세요."
        case .mediaServicesReset:
            return "오디오 서비스가 재시작됐어요. 다시 측정해 주세요."
        }
    }

}
