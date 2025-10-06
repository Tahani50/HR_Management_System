//
//  User.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    
    let id: Int
    let username: String
    var displayName: String?
    var userType: UserType
    var theme: Theme
}
