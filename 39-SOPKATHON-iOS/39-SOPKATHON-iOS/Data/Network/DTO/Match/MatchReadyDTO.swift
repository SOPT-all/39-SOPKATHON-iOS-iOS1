//
//  MatchReadyDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

struct MatchReadyRequestDTO: Encodable {

    /// 서버는 true만 받음. 준비 취소는 지원하지 않음.
    let isReady: Bool

}

/// 준비 상태 조회와 준비 완료 처리의 공통 응답.
struct MatchReadyResponseDTO: Decodable {

    let status: MatchStatusDTO
    let isMineReady: Bool
    let readyCount: Int
    let participantCount: Int
    let isAllReady: Bool

}
