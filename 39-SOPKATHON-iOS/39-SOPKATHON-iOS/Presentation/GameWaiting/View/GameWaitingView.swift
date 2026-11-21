//
//  GameWaitingView.swift
//  39-SOPKATHON-iOS
//
//  Created by Eda3399 on 11/22/26.
//

import SwiftUI

/// 상대 팀 매칭이 완료될 때까지 표시하는 대기 화면.
struct GameWaitingView: View {

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
        .background(.white)
        .ignoresSafeArea()
    }

}

private struct GameWaitingArtwork: View {

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("game_waiting_character")
                .resizable()
                .frame(
                    width: GameWaitingLayout.runnerFrame.width,
                    height: GameWaitingLayout.runnerFrame.height
                )
                .position(
                    x: GameWaitingLayout.runnerFrame.midX,
                    y: GameWaitingLayout.runnerFrame.midY
                )
                .accessibilityHidden(true)

            Image("game_waiting_message")
                .resizable()
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
    static let runnerFrame = CGRect(
        x: 134.7665,
        y: 242,
        width: 106.067,
        height: 88.8002
    )
    static let messageFrame = CGRect(
        x: 65.7189,
        y: 352,
        width: 234.2811,
        height: 108.4243
    )

}

#Preview("게임 대기") {
    GameWaitingView()
        .frame(width: 375, height: 812)
}
