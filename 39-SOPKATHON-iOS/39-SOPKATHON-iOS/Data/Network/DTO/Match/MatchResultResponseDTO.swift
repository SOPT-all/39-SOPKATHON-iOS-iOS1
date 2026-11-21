//
//  MatchResultResponseDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

/// 화면에서 쓰는 필드만 디코딩함. `winnerTeamSlot` 등은 실제 응답 타입을 확인하지 못해 제외함.
struct MatchResultResponseDTO: Decodable {

    let teams: [TeamResultResponseDTO]

}

struct TeamResultResponseDTO: Decodable {

    enum ResultType: String, Decodable {
        case win = "WIN"
        case lose = "LOSE"
        case draw = "DRAW"
    }

    // TODO: Swagger는 string(byte)로 표기함. 실제 응답이 숫자인지 확인 필요.
    let teamSlot: Int
    let schoolClassName: String
    let result: ResultType
    /// 말 달리기 경기에서만 값이 있음.
    let totalFinishTimeMilliseconds: Int64?

}
