//
//  GameRoomView.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 매칭 완료 후 준비 완료와 종목 선택을 하는 게임방 화면.
struct GameRoomView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = GameRoomViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TopNavi(title: "매칭 완료!") { dismiss() }

            MatchBanner(
                mySchool: viewModel.mySchool,
                opponentSchool: viewModel.opponentSchool,
                myMembers: viewModel.myMembers,
                opponentCount: viewModel.opponentCount
            )
            .frame(maxWidth: .infinity)
            .padding(.top, 2)

            Text(viewModel.guideText)
                .appFont(.captionLMedium)
                .foregroundStyle(Color(hex: 0x374151))
                .padding(.top, 8)
                .padding(.horizontal, 20)

            gameList
                .padding(.top, 15)
                .padding(.horizontal, 20)

            Spacer(minLength: 0)

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

    var gameList: some View {
        VStack(spacing: 27) {
            ForEach(Game.allCases, id: \.self) { game in
                GameCard(game: game, isSelected: viewModel.selectedGame == game) {
                    viewModel.select(game)
                }
                .disabled(!viewModel.isAllReady)
            }
        }
    }

}
