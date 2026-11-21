//
//  RootView.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import SwiftUI

struct RootView: View {

    @State private var viewModel = RootViewModel()
    /// 앱 시작 시 스플래시를 홈 위에 덮어 두고, 러너가 지나가면 걷어냄.
    @State private var isShowingSplash = true

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            HomeView(
                onStartGame: { viewModel.push(.matching) },
                onShowRanking: { viewModel.push(.ranking) }
            )
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
        .overlay {
            if isShowingSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .matching:
            GameWaitingView(onMatched: { viewModel.finishMatching() })
        case .gameRoom:
            GameRoomView(
                onBack: { viewModel.pop() },
                onSelectGame: { game in viewModel.push(.game(game)) }
            )
        case .game(let game):
            gameDestination(for: game)
                .toolbar(.hidden, for: .navigationBar)
        case .ranking:
            // 뒤로가기는 RankingView가 dismiss()로 처리함.
            RankingView()
        }
    }

    @ViewBuilder
    private func gameDestination(for game: Game) -> some View {
        switch game {
        case .horseRace:
            // 결과 팝업은 경마 화면이 직접 띄우고 버튼 신호만 받음. 다음 게임은 게임방에서 종목을 다시 고름.
            // TODO: 게임방이 매칭 정보를 넘기면 demo 대신 그 값을 전달 필요.
            HorseRaceView(
                match: .demo,
                onNextGame: { viewModel.pop() },
                onGoHome: { viewModel.popToRoot() }
            )
        case .tugOfWar:
            SoundTugView(
                onFinish: { score in
                    viewModel.finishGame(.tugOfWar(score: score))
                },
                onNextGame: { viewModel.finishToGameRoom(from: .tugOfWar) },
                onGoHome: { viewModel.popToRoot() }
            )
        }
    }

}
