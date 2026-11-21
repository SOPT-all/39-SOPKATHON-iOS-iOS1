//
//  RootViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import Observation

@Observable
final class RootViewModel {

    // 시스템 뒤로가기도 반영하도록 NavigationStack과 양방향 바인딩함.
    var path: [AppRoute] = [] {
        didSet {
            if path.last != oldValue.last {
                completedGameResult = nil
            }
        }
    }
    private(set) var completedGameResult: GameResult?

    func push(_ route: AppRoute) {
        guard path.last != route else { return }
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func finishGame(_ result: GameResult) {
        guard path.last == .game(result.game) else { return }
        completedGameResult = result
    }

    func startNextGame() {
        guard let result = completedGameResult,
              path.last == .game(result.game) else { return }
        let nextGame: Game = result.game == .horseRace ? .tugOfWar : .horseRace
        path[path.count - 1] = .game(nextGame)
    }

}
