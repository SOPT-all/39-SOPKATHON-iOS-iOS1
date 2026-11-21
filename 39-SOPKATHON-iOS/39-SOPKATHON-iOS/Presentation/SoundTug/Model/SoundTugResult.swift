//
//  SoundTugResult.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

struct SoundTugResult: Equatable {

    enum Outcome {
        case win
        case lose
        case draw
        case invalid
    }

    let mySchool: String
    let opponentSchool: String
    let myTeamTotalScore: Double
    let opponentTeamTotalScore: Double
    let outcome: Outcome

    var reward: Int? {
        switch outcome {
        case .win: 300
        case .lose: 0
        case .draw: 150
        case .invalid: nil
        }
    }

}
