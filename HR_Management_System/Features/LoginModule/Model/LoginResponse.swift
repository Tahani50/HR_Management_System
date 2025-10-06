//
//  LoginResponse.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct LoginResponse: Decodable {
    
    let jwt: String
    let user: User   // Use your existing User model
}
