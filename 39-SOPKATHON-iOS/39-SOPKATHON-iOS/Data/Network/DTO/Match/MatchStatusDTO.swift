//
//  MatchStatusDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/22/26.
//

enum MatchStatusDTO: String, Decodable {

    case searching = "SEARCHING"
    case found = "FOUND"
    case inProgress = "IN_PROGRESS"
    case finished = "FINISHED"
    case timeout = "TIMEOUT"
    case cancelled = "CANCELLED"
    case invalid = "INVALID"

}

struct MatchStatusResponseDTO: Decodable {

    let status: MatchStatusDTO

}
