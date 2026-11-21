//
//  GameResult.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import Foundation

enum GameResult: Equatable {

    case horseRace(seconds: TimeInterval)
    case tugOfWar(score: Double)

    var game: Game {
        switch self {
        case .horseRace: .horseRace
        case .tugOfWar: .tugOfWar
        }
    }

}
