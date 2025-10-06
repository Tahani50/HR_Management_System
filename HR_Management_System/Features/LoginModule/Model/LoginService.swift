//
//  LoginService.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct LoginService: LoginServiceProtocol {
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(identifier: email, password: password)

        let response: LoginResponse = try await NetworkManager.shared.request(
            endpoint: .login,
            body: request
        )
        TokenStore.shared.accessToken = response.jwt
        return response
    }
}
