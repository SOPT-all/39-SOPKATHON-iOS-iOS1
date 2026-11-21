//
//  HorseRaceResult.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import Foundation

/// 경기 결과 팝업에 표시하는 값.
struct HorseRaceResult: Equatable {

    let mySchool: String
    let opponentSchool: String
    /// 서버 `totalFinishTimeMilliseconds`와 같은 밀리초 단위임.
    let myTeamFinishTimeMilliseconds: Int64
    let opponentTeamFinishTimeMilliseconds: Int64
    /// 점수가 없으면 nil이며 "-"로 표시함.
    let score: Int?

    /// 완주 시간이 더 짧은 팀이 승리함.
    var isWin: Bool {
        myTeamFinishTimeMilliseconds < opponentTeamFinishTimeMilliseconds
    }

}
