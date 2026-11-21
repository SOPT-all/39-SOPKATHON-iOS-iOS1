//
//  RootView.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import SwiftUI

struct RootView: View {

    @State private var viewModel = RootViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            HomeView {
                viewModel.push(.gameRoom)
            }
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .gameRoom:
            GameRoomView(
                onBack: { viewModel.pop() },
                onSelectGame: { game in viewModel.push(.game(game)) }
            )
        case .game(let game):
            gameDestination(for: game)
                .toolbar(.hidden, for: .navigationBar)
        }
    }

    @ViewBuilder
    private func gameDestination(for game: Game) -> some View {
        switch game {
        case .horseRace:
            // 결과 팝업은 경마 화면이 직접 띄우고 버튼 신호만 받음. 다음 게임은 게임방에서 종목을 다시 고름.
            HorseRaceView(
                onNextGame: { viewModel.pop() },
                onGoHome: { viewModel.popToRoot() }
            )
        case .tugOfWar:
            SoundTugView(
                onFinish: { score in
                    viewModel.finishGame(.tugOfWar(score: score))
                },
                onNextGame: {
                    if viewModel.path.last == .game(.tugOfWar) {
                        viewModel.pop()
                    }
                },
                onGoHome: { viewModel.popToRoot() }
            )
        }
    }

}
