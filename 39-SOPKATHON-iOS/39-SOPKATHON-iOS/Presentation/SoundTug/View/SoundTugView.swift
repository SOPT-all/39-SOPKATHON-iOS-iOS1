//
//  SoundTugView.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import SwiftUI

struct SoundTugView: View {

    let onFinish: (Double) -> Void

    @Environment(\.scenePhase) private var scenePhase
    @State private var viewModel = SoundTugViewModel()

    private var isActive: Bool {
        viewModel.state == .measuring || viewModel.state == .finished
    }

    var body: some View {
        GeometryReader { geometry in
            let fullHeight = geometry.size.height
                + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            let scale = geometry.size.width / 375

            ZStack(alignment: .topLeading) {
                if isActive {
                    Image("sound_tug_shout_title")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280 * scale, height: 132 * scale)
                        .position(
                            x: geometry.size.width * 0.482,
                            y: fullHeight * 0.198 - geometry.safeAreaInsets.top
                        )
                        .accessibilityLabel("소리를 질러주세요")
                }

                SoundTugIllustration(
                    isActive: isActive,
                    progress: isActive ? viewModel.currentScore / 100 : 0
                )
                .frame(width: geometry.size.width, height: 164 * scale)
                .position(
                    x: geometry.size.width / 2,
                    y: fullHeight * 0.5 - geometry.safeAreaInsets.top
                )

                VStack(spacing: 0) {
                    Spacer(minLength: 16)
                    if isActive {
                        personalRecord
                            .padding(.bottom, 16)
                    }
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .appFont(.bodyMRegular)
                            .foregroundStyle(.mainRed)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 12)
                    }
                    measurementButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .onDisappear { viewModel.cancel() }
        .onChange(of: viewModel.state) { _, state in
            if state == .finished {
                onFinish(viewModel.highestScore)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                viewModel.cancel()
            }
        }
    }

    private var backgroundColor: Color {
        isActive
            ? Color(red: 1, green: 245 / 255, blue: 216 / 255)
            : Color(white: 217 / 255)
    }

    private var personalRecord: some View {
        VStack(spacing: 10) {
            HStack {
                Text("개인 기록")
                    .appFont(.bodyLSemiBold)
                Spacer()
                Text("이번 측정 최고 \(viewModel.highestScore, specifier: "%.1f")점")
                    .appFont(.bodyLSemiBold)
            }
            .foregroundStyle(.black)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Color(white: 254 / 255)
                    Rectangle()
                        .fill(.mainRed)
                        .frame(
                            width: geometry.size.width
                                * CGFloat(viewModel.currentScore / 100)
                        )
                    Text("현재 \(viewModel.currentScore, specifier: "%.1f")점")
                        .appFont(.bodyLSemiBold)
                        .foregroundStyle(Color(white: 84 / 255))
                        .padding(.horizontal, 14)
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .frame(height: 41)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                Text("현재 \(viewModel.currentScore, specifier: "%.1f")점, ")
                    + Text("이번 측정 최고 \(viewModel.highestScore, specifier: "%.1f")점")
            )
        }
        .monospacedDigit()
    }

    private var measurementButton: some View {
        Button {
            if viewModel.isRunning {
                viewModel.cancel()
            } else {
                viewModel.start()
            }
        } label: {
            Text(buttonTitle)
                .appFont(.bodyLSemiBold)
                .foregroundStyle(.white)
                .monospacedDigit()
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(.black, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            viewModel.state == .ready
                ? "\(viewModel.remainingSeconds)초 음량 측정 시작" : buttonTitle
        )
    }

    private var buttonTitle: String {
        switch viewModel.state {
        case .ready: return "준비..."
        case .preparing: return "마이크 준비 중 · 취소"
        case .measuring: return "남은 시간 \(viewModel.remainingSeconds)초 · 중지"
        case .finished: return "측정 완료 · 다시 측정하기"
        case .failed: return "다시 측정하기"
        }
    }

}

private struct SoundTugIllustration: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let isActive: Bool
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / 375
            let pull = CGFloat(min(1, max(0, progress))) * 220
            let prefix = isActive ? "sound_tug_active" : "sound_tug_ready"

            ZStack(alignment: .topLeading) {
                Image("\(prefix)_rope")
                    .resizable()
                    .frame(width: 375, height: 32)
                    .offset(y: 72)

                ForEach(0..<3) { index in
                    Image("\(prefix)_stitches")
                        .resizable()
                        .frame(width: 368, height: 6)
                        .offset(x: 7 + CGFloat(index) * 368 - pull, y: 85)
                }

                Image("sound_tug_pull_hand")
                    .resizable()
                    .frame(width: 150.342, height: 163.987)
                    .offset(x: -pull * 0.3)

                if isActive {
                    Image("sound_tug_rope_marker")
                        .resizable()
                        .frame(width: 20.4489, height: 107)
                        .offset(x: 336.9955 - pull, y: 28)
                }
            }
            .frame(width: 375, height: 164, alignment: .topLeading)
            .scaleEffect(scale, anchor: .topLeading)
            .animation(reduceMotion ? nil : .linear(duration: 0.08), value: progress)
        }
        .clipped()
        .accessibilityHidden(true)
    }

}
