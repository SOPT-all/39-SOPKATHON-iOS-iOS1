//
//  HeaderType.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

enum HeaderType {

    case basic
    case demoMember(memberID: Int)

    var value: [String: String] {
        var headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        if case .demoMember(let memberID) = self {
            headers["X-Demo-Member-Id"] = String(memberID)
        }
        return headers
    }

}
