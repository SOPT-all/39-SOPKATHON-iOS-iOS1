//
//  BaseService.swift
//  39-SOPKATHON-iOS
//
//  Created by 김세령 on 11/20/26.
//

import Foundation

final class BaseService {
    static let shared = BaseService()

    // TODO: 성공 코드 입력 필요. 공란이면 성공 처리 안 함.
    private let successCode = ""

    private let session: URLSession
    private let baseURLProvider: () -> String?

    private convenience init() {
        self.init(session: .shared) {
            // TODO: xcconfig에 BASE_URL 설정 후 Info.plist 연결 필요.
            Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
        }
    }

    init(session: URLSession, baseURLProvider: @escaping () -> String?) {
        self.session = session
        self.baseURLProvider = baseURLProvider
    }

    func request<Response: Decodable>(
        endPoint: EndPoint,
        body: (any Encodable)? = nil
    ) async throws -> Response {
        let request = try makeRequest(endPoint: endPoint, body: body)
        NetworkLogger.requestLog(request: request)
        return try await requestToResponse(request: request)
    }
}

private extension BaseService {
    func makeRequest(endPoint: EndPoint, body: (any Encodable)?) throws -> URLRequest {
        guard
            let address = baseURLProvider(),
            let baseURL = URL(string: address),
            baseURL.scheme == "https",
            baseURL.host != nil,
            var components = URLComponents(
                url: baseURL.appendingPathComponent(endPoint.url),
                resolvingAgainstBaseURL: false
            )
        else {
            throw NetworkError.urlError
        }
        if !endPoint.queryItems.isEmpty {
            components.queryItems = endPoint.queryItems
        }
        guard let url = components.url else {
            throw NetworkError.urlError
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 30
        request.httpMethod = endPoint.requestType.key
        request.allHTTPHeaderFields = endPoint.header
        if let body {
            request.httpBody = try makeRequestBody(data: body)
        }
        return request
    }

    func makeRequestBody<Body: Encodable>(data: Body) throws -> Data {
        do {
            return try JSONEncoder().encode(data)
        } catch {
            throw NetworkError.requestEncodingError
        }
    }

    func requestToResponse<Response: Decodable>(
        request: URLRequest
    ) async throws -> Response {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            NetworkLogger.errorLog(error: error)
            if error is CancellationError { throw error }
            if let error = error as? URLError, error.code == .cancelled {
                throw CancellationError()
            }
            throw NetworkError.transportError(error)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpURLResponseError
        }
        NetworkLogger.responseLog(response: httpResponse, data: data)

        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(
                APIErrorResponseDTO.self,
                from: data
            )
            throw NetworkError.httpError(
                statusCode: httpResponse.statusCode,
                code: errorResponse?.code
            )
        }

        // TODO: 서버 응답 형식에 맞춰 BaseResponseDTO·디코딩 수정 필요.
        let decoded: BaseResponseDTO<Response>
        do {
            decoded = try JSONDecoder().decode(BaseResponseDTO<Response>.self, from: data)
        } catch {
            throw NetworkError.responseDecodingError(error)
        }
        guard !successCode.isEmpty, decoded.code == successCode else {
            throw NetworkError.serverError(code: decoded.code)
        }
        guard let result = decoded.data else {
            throw NetworkError.noData
        }
        return result
    }
}
