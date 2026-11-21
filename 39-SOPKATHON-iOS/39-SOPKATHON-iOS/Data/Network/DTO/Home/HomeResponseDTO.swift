//
//  HomeResponseDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

/// `GET /api/v1/home` 응답의 `data`.
struct HomeResponseDTO: Decodable {

    let me: HomeMeDTO
    let school: HomeSchoolDTO
    let schoolClass: HomeSchoolClassDTO
    let members: [HomeMemberDTO]

}

struct HomeMeDTO: Decodable {

    let memberID: Int
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case displayName
    }

}

struct HomeSchoolDTO: Decodable {

    let schoolID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case schoolID = "schoolId"
        case name
    }

}

struct HomeSchoolClassDTO: Decodable {

    let schoolClassID: Int
    let grade: Int
    let classNumber: Int

    enum CodingKeys: String, CodingKey {
        case schoolClassID = "schoolClassId"
        case grade
        case classNumber
    }

}

struct HomeMemberDTO: Decodable {

    let memberID: Int
    let displayName: String
    let isMe: Bool

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case displayName
        case isMe
    }

}
