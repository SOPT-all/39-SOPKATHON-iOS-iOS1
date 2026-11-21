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
    /// 완주 후 경기 완료 여부를 확인하는 중.
    case finished(record: TimeInterval)
    /// 경기 완료가 확인되어 결과를 받은 상태.
    case completed(HorseRaceResult)
}
