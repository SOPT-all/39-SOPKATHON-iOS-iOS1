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
        if case .game = route {
            guard path.last == .gameRoom else { return }
        }
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    /// 매칭 대기 화면을 게임방으로 교체함. 게임방에서 뒤로 가면 대기 화면을 건너뛰고 홈으로 감.
    func finishMatching() {
        guard path.last == .matching else { return }
        path[path.count - 1] = .gameRoom
    }

    func finishToGameRoom(from game: Game) {
        guard path.last == .game(game) else { return }
        path.removeLast()
    }

    func finishGame(_ result: GameResult) {
        guard path.last == .game(result.game) else { return }
        completedGameResult = result
    }

    func startNextGame() {
        guard case .game(let game) = path.last else { return }
        let nextGame: Game = switch game {
        case .horseRace: .tugOfWar
        case .tugOfWar: .horseRace
        }
        path[path.count - 1] = .game(nextGame)
    }

}
