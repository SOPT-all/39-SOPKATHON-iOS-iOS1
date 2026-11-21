//
//  HorseRacePhase.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import Foundation

enum HorseRacePhase: Equatable {
    case ready
    case running(startDate: Date)
    case finished(record: TimeInterval)
}
