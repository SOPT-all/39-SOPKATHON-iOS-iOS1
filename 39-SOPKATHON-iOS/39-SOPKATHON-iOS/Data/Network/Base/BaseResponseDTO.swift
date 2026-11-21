//
//  BaseResponseDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

struct BaseResponseDTO<T: Decodable>: Decodable {

    let status: Int
    let code: String
    let message: String
    let data: T?

}

struct APIErrorResponseDTO: Decodable {

    let status: Int
    let code: String
    let message: String

}
