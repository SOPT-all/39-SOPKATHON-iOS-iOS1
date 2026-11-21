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
    /// 경기가 시간 초과·취소·무효로 끝났거나 경기 정보가 없어 결과를 받을 수 없는 상태.
    case aborted
}
