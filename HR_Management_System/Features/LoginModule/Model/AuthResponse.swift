//
//  AuthResponse.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct AuthResponse: Codable {
    
    let jwt: String
    let user: User
}
