//
//  GameCountdownOverlay.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

import Lottie

/// 종목 확정 후 화면 전체를 어둡게 덮고 3·2·1 Lottie 애니메이션을 재생하는 오버레이(Figma 홈-9~11).
struct GameCountdownOverlay: View {

    /// 3초 애니메이션 재생이 끝나면 한 번 호출함.
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            // Figma `Rectangle 33`: #000000, 불투명도 70%
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: Layout.textSpacing) {
                LottieView(animation: .named("countdown-3-2-1"))
                    .playing(loopMode: .playOnce)
                    .animationDidFinish { _ in onFinish() }
                    .frame(width: Layout.canvasSize, height: Layout.canvasSize)

                Text("가장 먼저 선택된\n게임으로 시작해요.")
                    .appFont(.bodyMSemiBold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            // Figma 숫자·문구 묶음의 세로 위치(812pt 중 336~542)에 맞춤.
            .offset(y: -6)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("3, 2, 1. 가장 먼저 선택된 게임으로 시작해요.")
    }

}

private extension GameCountdownOverlay {

    enum Layout {
        /// Lottie 캔버스(250x250). 숫자는 캔버스 안 y 55~195에 그려져 Figma 숫자 크기(140pt)와 같음.
        static let canvasSize: CGFloat = 250
        /// Figma에서 숫자 아래 22pt에 문구가 옴. 캔버스 아래 여백(55pt)만큼 당겨서 맞춤.
        static let textSpacing: CGFloat = 22 - 55
    }

}
