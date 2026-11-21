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

        // 시연용 dBFS 보정값임. 보정된 음압(SPL) 측정값이 아님.
        let decibels = 20 * log10(rootMeanSquare) + 120
        return min(120, max(0, decibels))
    }

}
