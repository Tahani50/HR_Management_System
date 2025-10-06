//
//  LoginViewModel.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var loginResponse: LoginResponse?
    @Published var errorMessage: String?
    
    private let loginService: LoginServiceProtocol
    
    init(loginService: LoginServiceProtocol = LoginService()) {
        self.loginService = loginService
    }
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await loginService.login(email: email, password: password)
            self.loginResponse = result
        } catch {
            self.errorMessage = (error as? NetworkError)?.localizedDescription ?? error.localizedDescription
            print(errorMessage)
        }
        
        isLoading = false
    }
    
    func logout() {
        TokenStore.shared.accessToken = nil
        loginResponse = nil
        password = ""
        email = ""    // optional: clear email too
    }
}
