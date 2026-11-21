//
//  SoundTugMatchContext.swift
//  39-SOPKATHON-iOS
//
//  Created by ser0kim on 11/22/26.
//

import Foundation

struct SoundTugMatchContext {

    let matchID: Int
    let memberID: Int
    let myTeamSlot: Int

    static func load(bundle: Bundle = .main) throws -> SoundTugMatchContext {
        guard let matchValue = bundle.object(forInfoDictionaryKey: "MATCH_ID") as? String,
              let memberValue = bundle.object(forInfoDictionaryKey: "MEMBER_ID") as? String,
              let matchID = Int(matchValue.trimmingCharacters(in: .whitespacesAndNewlines)),
              let memberID = Int(memberValue.trimmingCharacters(in: .whitespacesAndNewlines)),
              matchID > 0, memberID > 0 else {
            throw SoundTugAPIError.invalidConfiguration
        }
        return SoundTugMatchContext(matchID: matchID, memberID: memberID, myTeamSlot: 1)
    }

}

enum SoundTugAPIError: LocalizedError {

    case invalidConfiguration
    case invalidSubmission
    case invalidResult
    case resultPending
    case resultTimedOut

    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:
            return "경기·참가자 설정을 확인해 주세요."
        case .invalidSubmission:
            return "제출된 기록을 확인할 수 없어요. 다시 시도해 주세요."
        case .invalidResult:
            return "현재 경기의 팀 결과를 확인할 수 없어요."
        case .resultPending:
            return "다른 참가자의 기록을 기다리고 있어요."
        case .resultTimedOut:
            return "아직 결과가 준비되지 않았어요. 다시 조회해 주세요."
        }
    }

}
