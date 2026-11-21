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
    /// 서버가 정한 우리 팀 승패. 무승부는 팝업에 별도 표시가 없어 패배로 둠.
    let isWin: Bool
    /// 점수가 없으면 nil이며 "-"로 표시함.
    let score: Int?

}

extension HorseRaceResult {

    /// 우리 팀·상대 팀 결과나 완주 시간이 없으면 nil.
    init?(response: MatchResultResponseDTO, myTeamSlot: Int) {
        guard
            let myTeam = response.teams.first(where: { $0.teamSlot == myTeamSlot }),
            let opponentTeam = response.teams.first(where: { $0.teamSlot != myTeamSlot }),
            let myTeamFinishTime = myTeam.totalFinishTimeMilliseconds,
            let opponentTeamFinishTime = opponentTeam.totalFinishTimeMilliseconds
        else {
            return nil
        }
        self.init(
            mySchool: myTeam.schoolClassName,
            opponentSchool: opponentTeam.schoolClassName,
            myTeamFinishTimeMilliseconds: myTeamFinishTime,
            opponentTeamFinishTimeMilliseconds: opponentTeamFinishTime,
            isWin: myTeam.result == .win,
            // TODO: 점수 필드가 서버 명세에 없어 "-"로 표시함. 필드 추가 시 연결 필요.
            score: nil
        )
    }

}
