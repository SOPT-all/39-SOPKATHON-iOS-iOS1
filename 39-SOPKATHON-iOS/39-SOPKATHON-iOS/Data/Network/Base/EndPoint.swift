//
//  EndPoint.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import Foundation

// TODO: API 명세 확정 후 case 추가 필요.
enum EndPoint {
    var url: String {
        // TODO: switch self로 API별 상대 경로 반환 필요. 도메인 제외.
        ""
    }

    var requestType: HTTPMethodType {
        // TODO: switch self로 API별 HTTP 메서드 반환 필요.
        // .get은 임시 기본값임.
        .get
    }

    var queryItems: [URLQueryItem] {
        // TODO: 필요한 API에 URLQueryItem 추가 필요.
        []
    }

    var header: [String: String] {
        // TODO: 인증 필요 시 서버 명세에 맞는 헤더 연결 필요.
        HeaderType.basic.value
    }
}
