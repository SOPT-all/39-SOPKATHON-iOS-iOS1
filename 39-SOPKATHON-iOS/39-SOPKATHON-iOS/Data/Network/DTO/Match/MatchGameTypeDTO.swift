//
//  MatchGameTypeDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

enum GameTypeDTO: String, Codable {

    case horseTap = "HORSE_TAP"
    case voiceTug = "VOICE_TUG"

}

struct MatchGameTypeRequestDTO: Encodable {

    let gameType: GameTypeDTO

}

/// 확정 종목 조회와 선착순 종목 확정의 공통 응답. 화면에서 쓰는 필드만 디코딩함.
struct MatchGameTypeResponseDTO: Decodable {

    /// 확정 전이면 nil.
    let gameType: GameTypeDTO?
    let status: MatchStatusDTO

}
