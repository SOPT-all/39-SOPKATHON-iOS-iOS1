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
        // TODO: 결과 뷰 추가 시 completedGameResult로 표시하고 startNextGame/popToRoot 연결 필요.
        switch game {
        case .horseRace:
            HorseRaceView { seconds in
                viewModel.finishGame(.horseRace(seconds: seconds))
            }
        case .tugOfWar:
            SoundTugView { score in
                viewModel.finishGame(.tugOfWar(score: score))
            }
        }
    }

}
