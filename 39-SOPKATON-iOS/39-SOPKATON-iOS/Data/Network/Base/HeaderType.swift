//
//  HeaderType.swift
//  39-SOPKATON-iOS
//
//  Created by 김세령 on 11/20/26.
//

enum HeaderType {
    // TODO: JSON 공통 헤더임. 서버 명세에 맞춰 수정 필요.
    // 인증 방식 확정 후 별도 헤더 추가 필요.
    case basic

    var value: [String: String] {
        switch self {
        case .basic:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
}
