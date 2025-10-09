//
//  User.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    
    let id: Int
    let documentId: String
    let username: String
    let email: String
    let provider: String
    let confirmed: Bool
    let blocked: Bool
    let createdAt: Date
    let updatedAt: Date
    let publishedAt: Date
    let userType: UserType
    let theme: Theme
    let displayName: String?
}
