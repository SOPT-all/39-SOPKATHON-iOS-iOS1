//
//  SoundLevelScore.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import Foundation

enum SoundLevelScore {

    nonisolated static func calculate(rootMeanSquare: Double) -> Double {
        guard rootMeanSquare.isFinite, rootMeanSquare > 0 else { return 0 }

        let decibels = 20 * log10(rootMeanSquare)
        let score = (decibels + 60) / 60 * 100
        let boostStartScore = 40.0
        let fullBoostScore = 80.0
        let maximumBoost = 20.0
        let progress = min(1, max(0, (score - boostStartScore)
            / (fullBoostScore - boostStartScore)))
        let adjustedScore = score + maximumBoost * progress * progress
        return min(100, max(0, adjustedScore))
    }

}
