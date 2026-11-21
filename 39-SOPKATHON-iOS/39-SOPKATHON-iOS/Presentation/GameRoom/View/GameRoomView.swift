//
//  GameRoomView.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 매칭 완료 후 준비 완료와 종목 선택을 하는 게임방 화면.
struct GameRoomView: View {

    let onBack: () -> Void
    let onSelectGame: (Game) -> Void

    @State private var viewModel = GameRoomViewModel()

    var body: some View {
        VStack(spacing: 0) {
            TopNavi(title: "매칭 완료!", onBack: onBack)

            // 화면 높이가 작거나 가로 방향이면 카드가 넘치므로 가운데 영역만 스크롤함.
            ScrollView {
                content
                    .padding(.bottom, 16)
            }
            .scrollBounceBehavior(.basedOnSize)

            PrimaryButton(title: "준비 완료", isEnabled: !viewModel.isMeReady) {
                viewModel.ready()
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }

}

private extension GameRoomView {

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            MatchBanner(
                mySchool: viewModel.mySchool,
                opponentSchool: viewModel.opponentSchool,
                myMembers: viewModel.myMembers,
                opponentCount: viewModel.opponentCount
            )
            .frame(maxWidth: .infinity)
            .padding(.top, 2)

            Text("전원 준비완료! 플레이할 종목을 선택해 주세요.")
                .appFont(.captionLMedium)
                // Figma 텍스트 색 #374151. 디자인시스템 grey 토큰에 없는 값이라 직접 지정함.
                .foregroundStyle(Color(hex: 0x374151))
                .padding(.top, 8)
                .padding(.horizontal, 20)

            gameList
                .padding(.top, 15)
                .padding(.horizontal, 20)
        }
    }

    var gameList: some View {
        VStack(spacing: 27) {
            ForEach(Game.allCases, id: \.self) { game in
                GameCard(
                    game: game,
                    isSelected: viewModel.selectedGame == game,
                    isEnabled: viewModel.isAllReady
                ) {
                    if viewModel.select(game) {
                        onSelectGame(game)
                    }
                }
            }
        }
    }

}
