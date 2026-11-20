//
//  HTTPMethodType.swift
//  39-SOPKATON-iOS
//
//  Created by 김세령 on 11/20/26.
//

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension HTTPMethodType {
    var key: String { rawValue }
}
