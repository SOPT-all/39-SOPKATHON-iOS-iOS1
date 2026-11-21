//
//  GameRoomMatch.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

import Foundation

/// 게임방 API 호출에 필요한 경기·참가자 정보.
struct GameRoomMatch {

    let matchID: Int
    let memberID: Int

}

extension GameRoomMatch {

    // TODO: 온보딩·매칭 연동 후 서버에서 받은 값으로 교체 필요. 지금은 Config.xcconfig 시연값을 읽음.
    /// xcconfig 값이 하나라도 없거나 숫자가 아니면 nil.
    static var demo: GameRoomMatch? {
        guard
            let matchID = infoInt(for: "MATCH_ID"),
            let memberID = infoInt(for: "MEMBER_ID")
        else {
            return nil
        }
        return GameRoomMatch(matchID: matchID, memberID: memberID)
    }

    private static func infoInt(for key: String) -> Int? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return nil
        }
        return Int(value)
    }

}
