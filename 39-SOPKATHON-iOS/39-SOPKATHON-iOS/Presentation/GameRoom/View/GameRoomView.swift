//
//  GameRoomView.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import SwiftUI

/// 매칭 완료 후 양 팀 준비 → 종목 선택 → 3·2·1 카운트다운을 거쳐 게임을 시작하는 게임방 화면.
struct GameRoomView: View {

    let onBack: () -> Void
    /// 카운트다운이 끝난 뒤 확정된 종목으로 한 번 호출함.
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

            bottomButton
                .padding(.horizontal, 20)
        }
        .overlay {
            if viewModel.isCountingDown {
                GameCountdownOverlay(onFinish: viewModel.finishCountdown)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase)
        .onChange(of: viewModel.startedGame) { _, game in
            guard let game else { return }
            onSelectGame(game)
        }
        // 게임 화면에서 돌아오면 다시 준비부터 시작할 수 있게 함.
        .onAppear { viewModel.resetAfterGame() }
        .onDisappear { viewModel.stop() }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }

}

private extension GameRoomView {

    var isWaiting: Bool {
        viewModel.phase == .waiting
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isWaiting {
                MatchBanner(
                    mySchool: viewModel.mySchool,
                    opponentSchool: viewModel.opponentSchool,
                    myMembers: viewModel.myMembers,
                    opponentMembers: viewModel.opponentMembers,
                    isMyTeamReady: viewModel.isMyTeamReady,
                    isOpponentReady: viewModel.isOpponentReady
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Text(isWaiting ? "준비완료를 눌러주세요!" : "전원 준비완료! 플레이할 종목을 선택해 주세요.")
                .appFont(.captionLMedium)
                // Figma 텍스트 색 #374151. 디자인시스템 grey 토큰에 없는 값이라 직접 지정함.
                .foregroundStyle(Color(hex: 0x374151))
                .padding(.top, isWaiting ? 8 : 15)
                .padding(.horizontal, 20)

            gameList
                .padding(.top, 15)
                .padding(.horizontal, 20)
        }
    }

    var gameList: some View {
        VStack(spacing: isWaiting ? 21 : 18) {
            ForEach(Game.allCases, id: \.self) { game in
                GameCard(game: game, status: status(of: game)) {
                    viewModel.select(game)
                }
            }
        }
    }

    func status(of game: Game) -> GameCard.Status {
        switch viewModel.phase {
        case .waiting: .locked
        case .selecting: .available
        case .selected, .countdown, .started:
            viewModel.selectedGame == game ? .selected : .unselected
        }
    }

    /// 준비 전에는 "준비 완료", 우리 팀 준비 후에는 "취소", 종목 선택부터는 버튼 없음.
    @ViewBuilder
    var bottomButton: some View {
        if isWaiting {
            if viewModel.isMyTeamReady {
                Button(action: viewModel.cancelReady) {
                    Text("취소")
                        .font(AppFont.subHeaderSSemiBold.font)
                        .foregroundStyle(Color(hex: 0x888888))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(hex: 0xD9D9D9))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
            } else {
                PrimaryButton(title: "준비 완료", action: viewModel.ready)
            }
        }
    }

}
