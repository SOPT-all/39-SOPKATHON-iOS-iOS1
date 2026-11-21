//
//  Game+GameTypeDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

extension Game {

    init(gameType: GameTypeDTO) {
        switch gameType {
        case .horseTap: self = .horseRace
        case .voiceTug: self = .tugOfWar
        }
    }

    var gameType: GameTypeDTO {
        switch self {
        case .horseRace: .horseTap
        case .tugOfWar: .voiceTug
        }
    }

}
