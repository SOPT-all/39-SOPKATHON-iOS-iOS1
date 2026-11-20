//
//  BaseResponseDTO.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

// TODO: code(String), data(T?)는 임시 구조임.
// 서버 명세에 맞춰 키·타입·중첩 구조 수정 필요.
struct BaseResponseDTO<T: Decodable>: Decodable {
    let code: String
    let data: T?
}

// TODO: 실패 응답 코드의 키·타입 수정 필요.
struct APIErrorResponseDTO: Decodable {
    let code: String
}
