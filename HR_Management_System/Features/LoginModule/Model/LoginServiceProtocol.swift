//
//  LoginServiceProtocol.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

protocol LoginServiceProtocol {
    
    func login(email: String, password: String) async throws -> LoginResponse
}
