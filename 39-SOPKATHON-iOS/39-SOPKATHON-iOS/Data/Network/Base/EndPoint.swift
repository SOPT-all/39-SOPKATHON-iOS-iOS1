//
//  EndPoint.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import Foundation

enum EndPoint {

    case home(memberID: Int, grade: Int, classNumber: Int)
    case submitVoiceRecord(matchID: Int, memberID: Int)
    case submitHorseRecord(matchID: Int, memberID: Int)
    case updateReady(matchID: Int, memberID: Int)
    case gameType(matchID: Int)
    case updateGameType(matchID: Int, memberID: Int)
    case voiceResult(matchID: Int)
    case matchStatus(matchID: Int, memberID: Int)
    case matchResult(matchID: Int, memberID: Int)
    case readyStatus(matchID: Int, memberID: Int)
    case horseResult(matchID: Int, memberID: Int)

    var url: String {
        switch self {
        case .home:
            return "api/v1/home"
        case .submitVoiceRecord(let matchID, _):
            return "api/v1/game-matches/\(matchID)/participants/me/voice-record"
        case .submitHorseRecord(let matchID, _):
            return "api/v1/game-matches/\(matchID)/participants/me/horse-record"
        case .updateReady(let matchID, _):
            return "api/v1/game-matches/\(matchID)/participants/me/ready"
        case .gameType(let matchID), .updateGameType(let matchID, _):
            return "api/v1/game-matches/\(matchID)/game-type"
        case .voiceResult(let matchID):
            return "api/v1/game-matches/\(matchID)/voice-result"
        case .matchStatus(let matchID, _):
            return "api/v1/game-matches/\(matchID)/status"
        case .matchResult(let matchID, _):
            return "api/v1/game-matches/\(matchID)/result"
        case .readyStatus(let matchID, _):
            return "api/v1/game-matches/\(matchID)/ready"
        case .horseResult(let matchID, _):
            return "api/v1/game-matches/\(matchID)/horse-result"
        }
    }

    var requestType: HTTPMethodType {
        switch self {
        case .submitVoiceRecord, .submitHorseRecord:
            return .put
        case .updateReady, .updateGameType:
            return .patch
        case .home, .gameType, .voiceResult, .matchStatus,
             .matchResult, .readyStatus, .horseResult:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .home(_, let grade, let classNumber):
            return [
                URLQueryItem(name: "grade", value: String(grade)),
                URLQueryItem(name: "classNumber", value: String(classNumber))
            ]
        default:
            return []
        }
    }

    var header: [String: String] {
        switch self {
        case .home(let memberID, _, _),
             .submitVoiceRecord(_, let memberID),
             .submitHorseRecord(_, let memberID),
             .updateReady(_, let memberID),
             .updateGameType(_, let memberID),
             .matchStatus(_, let memberID),
             .matchResult(_, let memberID),
             .readyStatus(_, let memberID),
             .horseResult(_, let memberID):
            return HeaderType.demoMember(memberID: memberID).value
        case .gameType, .voiceResult:
            return HeaderType.basic.value
        }
    }

}
