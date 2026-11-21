//
//  HorseRaceView.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import SwiftUI

struct HorseRaceView: View {

    /// 결과 팝업의 "다음 게임 이어가기"를 누르면 호출함.
    let onNextGame: () -> Void
    /// 결과 팝업의 "홈 화면으로 이동"을 누르면 호출함.
    let onGoHome: () -> Void

    @State private var viewModel: HorseRaceViewModel

    /// - Parameter match: nil이면 완주 후 결과를 받을 수 없어 비정상 종료 알림을 띄움.
    init(
        match: HorseRaceMatch?,
        onNextGame: @escaping () -> Void,
        onGoHome: @escaping () -> Void
    ) {
        self.onNextGame = onNextGame
        self.onGoHome = onGoHome
        _viewModel = State(initialValue: HorseRaceViewModel(match: match))
    }

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
                            runnerOffset: proxy.size.width * viewModel.runnerProgress,
                            isSecondRunnerPose: viewModel.isSecondRunnerPose
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            // 준비·완주 중 탭은 ViewModel이 무시함. disabled로 막으면 버튼이 흐려져 디자인과 달라짐.
            HorseRaceTapButton(title: viewModel.buttonTitle) {
                viewModel.tap()
            }
            .padding(.horizontal, 20)
        }
        .overlay {
            if viewModel.isGameOver {
                HorseRaceGameOver(
                    result: viewModel.result,
                    onNextGame: onNextGame,
                    onGoHome: onGoHome
                )
            }
        }
        .alert(
            "경기 결과를 확인할 수 없어요",
            // 확인 버튼이 화면을 닫으므로 알림을 닫을 때 상태를 되돌리지 않음.
            isPresented: .constant(viewModel.isAborted)
        ) {
            Button("홈으로 이동", action: onGoHome)
        } message: {
            Text("경기가 정상적으로 끝나지 않았어요.")
        }
        .task(id: viewModel.isReady) {
            await viewModel.startAfterCountdown()
        }
        .task(id: viewModel.isWaitingForResult) {
            await viewModel.waitForResult()
        }
    }

}

/// 진행 중 화면의 안내 문구와 달리는 사람. Figma 375 x 812 프레임 좌표에 맞춰 배치함.
private struct HorseRaceRunningOverlay: View {

    /// 트랙 끝에 닿은 뒤 달리는 사람과 그림자를 오른쪽으로 미는 거리.
    let runnerOffset: CGFloat
    /// true면 Figma "달리기2", false면 "달리기1" 자세를 그림.
    let isSecondRunnerPose: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                // Figma 달리기 에셋(379 x 323.671)을 화면 속 달리는 사람 폭 115pt로 줄임.
                // 에셋이 runner 프레임보다 위로 1.78% 커서 그만큼 위로 올림.
                Image(isSecondRunnerPose ? .horseRaceRunner2 : .horseRaceRunner1)
                    .resizable()
                    .frame(width: 115, height: 98.211)
                    .offset(x: 132.067, y: 288.862)

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
