//
//  GameWaitingView.swift
//  39-SOPKATHON-iOS
//
//  Created by Eda3399 on 11/22/26.
//

import SwiftUI

import Lottie

/// 상대 팀 매칭이 완료될 때까지 표시하는 대기 화면.
struct GameWaitingView: View {

    /// 매칭이 끝나면 한 번 호출함.
    let onMatched: () -> Void

    private let matchingDuration: Duration = .seconds(4)

    var body: some View {
        GeometryReader { geometry in
            let widthScale = geometry.size.width / GameWaitingLayout.canvasWidth
            let heightScale = geometry.size.height / GameWaitingLayout.canvasHeight

            GameWaitingArtwork()
                .scaleEffect(min(widthScale, heightScale))
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
        }
        // Figma 최종 UI `탐색중` 배경(Gray/gray-700). 디자인시스템 grey 토큰에 없는 값이라 직접 지정함.
        .background(Color(hex: 0x545454))
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .task {
            // TODO: 매칭 API 연동 전까지 고정 시간 대기 후 매칭 완료로 처리함.
            do {
                try await Task.sleep(for: matchingDuration)
            } catch {
                // 화면을 벗어나 취소된 경우라 이동하지 않음.
                return
            }
            onMatched()
        }
    }

}

private struct GameWaitingArtwork: View {

    var body: some View {
        ZStack(alignment: .topLeading) {
            LottieView(animation: .named("runner-run-cycle"))
                .playing(loopMode: .loop)
                .frame(
                    width: GameWaitingLayout.runnerFrame.width,
                    height: GameWaitingLayout.runnerFrame.height
                )
                .position(
                    x: GameWaitingLayout.runnerFrame.midX,
                    y: GameWaitingLayout.runnerFrame.midY
                )
                .accessibilityHidden(true)

            Image(.gameWaitingMessage)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
                .frame(
                    width: GameWaitingLayout.messageFrame.width,
                    height: GameWaitingLayout.messageFrame.height
                )
                .position(
                    x: GameWaitingLayout.messageFrame.midX,
                    y: GameWaitingLayout.messageFrame.midY
                )
                .accessibilityLabel("상대를 찾고 있어요")
        }
        .frame(
            width: GameWaitingLayout.canvasWidth,
            height: GameWaitingLayout.canvasHeight
        )
    }

}

private enum GameWaitingLayout {

    static let canvasWidth: CGFloat = 375
    static let canvasHeight: CGFloat = 812
    /// Figma `Component 1`(러너 Lottie 캔버스 전체) 위치·크기.
    static let runnerFrame = CGRect(
        x: 98.96,
        y: 197.56,
        width: 177.67,
        height: 177.67
    )
    static let messageFrame = CGRect(
        x: 65.7189,
        y: 352,
        width: 234.2811,
        height: 108.4243
    )

}
