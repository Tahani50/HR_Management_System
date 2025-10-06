//
//  LoginRequest.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct LoginRequest: Encodable {
    
    let identifier: String
    let password: String
}
