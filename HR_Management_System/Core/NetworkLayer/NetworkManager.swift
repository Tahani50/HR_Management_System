//
//  NetworkManager.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .custom { dec in
            let str = try dec.singleValueContainer().decode(String.self)
            if let date = ISO8601DateFormatter.fractional.date(from: str)
                ?? ISO8601DateFormatter.basic.date(from: str) {
                return date
            }
            throw DecodingError.dataCorrupted(.init(
                codingPath: dec.codingPath,
                debugDescription: "Invalid ISO8601 date: \(str)"
            ))
        }
        return d
    }()
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint.url) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = TokenStore.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = body, request.httpMethod != "GET", request.httpMethod != "HEAD" {
            if endpoint.requiresStrapiDataWrapper {
                let wrapped = StrapiBody(data: AnyEncodable(body))
                request.httpBody = try encoder.encode(wrapped)
            } else {
                request.httpBody = try encoder.encode(AnyEncodable(body))
            }
        }
        
        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
            print("➡️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")\n\(str)")
        } else {
            print("➡️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NetworkError.unknown }
        guard 200..<300 ~= http.statusCode else {
            let snippet = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            print("❌ HTTP \(http.statusCode): \(snippet)")
            throw NetworkError.requestFailed(http.statusCode)
        }
        
        do { return try decoder.decode(T.self, from: data) }
        catch {
            let raw = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            print("❌ Decoding failed. Raw body:\n\(raw)")
            throw NetworkError.decodingFailed
        }
    }
}

// MARK: - Small encodable helpers

/// Wrap any Encodable (including already-encoded structs) without concrete type erasure hassles.
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init<T: Encodable>(_ wrapped: T) { _encode = wrapped.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

/// Strapi v4 body wrapper: { "data": ... }
struct StrapiBody<T: Encodable>: Encodable {
    let data: T
}

// MARK: - ISO8601 helpers (fractional seconds support)

private extension ISO8601DateFormatter {
    static let fractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
    static let basic: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()
}
