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

    // Encodes fine as-is
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    // ✅ Decode ISO8601 with/without fractional seconds
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
        guard let url = URL(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        print("➡️ \(request.httpMethod ?? "GET") \(url.absoluteString)")
        request.httpMethod = endpoint.method.rawValue

        // Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = TokenStore.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Custom headers
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Request body
        if let body = body {
            if endpoint.requiresStrapiDataWrapper {
                // Wrap as { "data": ... } for Strapi v4
                let wrapped = StrapiBody(data: AnyEncodable(body))
                request.httpBody = try encoder.encode(wrapped)
            } else {
                request.httpBody = try encoder.encode(AnyEncodable(body))
            }
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            // ✅ Log server body for quick debugging
            let snippet = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            print("❌ HTTP \(httpResponse.statusCode): \(snippet)")
            throw NetworkError.requestFailed(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // ✅ Show raw body when decoding fails
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
