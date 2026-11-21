//
//  HorseRaceView.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

struct HorseRaceView: View {

    /// 완주 시 기록(초)을 한 번 전달함.
    let onFinish: (TimeInterval) -> Void

    @State private var viewModel = HorseRaceViewModel()

    var body: some View {
        // 버튼은 안전 영역 기준으로 두고 배경만 화면 끝까지 그리기 위해 ZStack으로 감쌈.
        ZStack {
            HorseRaceTrack(
                style: viewModel.isReady ? .ready : .running,
                progress: viewModel.trackProgress
            )
            // 812pt 고정 높이가 안전 영역보다 커서 레이아웃에 넣으면 버튼 위치가 밀리므로 overlay로 올림.
            .overlay(alignment: .top) {
                if !viewModel.isReady {
                    GeometryReader { proxy in
                        // 화면 폭만큼 밀면 그림자 왼쪽 끝까지 화면 밖으로 나감.
                        HorseRaceRunningOverlay(
                            runnerOffset: proxy.size.width * viewModel.runnerProgress
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            // 준비·완주 중 탭은 ViewModel이 무시함. disabled로 막으면 버튼이 흐려져 디자인과 달라짐.
            HorseRaceTapButton(title: viewModel.buttonTitle, action: tap)
                .padding(.horizontal, 20)
        }
        .task(id: viewModel.isReady) {
            await viewModel.startAfterCountdown()
        }
    }

    private func tap() {
        guard let record = viewModel.tap() else { return }
        onFinish(record)
    }

}

/// 진행 중 화면의 안내 문구와 달리는 사람. Figma 375 x 812 프레임 좌표에 맞춰 배치함.
private struct HorseRaceRunningOverlay: View {

    /// 트랙 끝에 닿은 뒤 달리는 사람과 그림자를 오른쪽으로 미는 거리.
    let runnerOffset: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                Image(.horseRaceRunner)
                    .offset(x: 132.067, y: 290.583)

                Image(.horseRaceRunnerShadow)
                    .offset(x: 0, y: 342.164)
            }
            .offset(x: runnerOffset)
            .animation(.easeOut(duration: 0.15), value: runnerOffset)

            Image(.horseRaceTitle)
                .offset(x: 51, y: 112)
                .accessibilityLabel("화면을 연타해주세요")
        }
        .frame(width: 375, height: 812, alignment: .topLeading)
        .allowsHitTesting(false)
    }

}
