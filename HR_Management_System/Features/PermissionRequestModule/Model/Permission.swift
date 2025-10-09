//
//  Permission.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct Permission: Codable, Identifiable {
    let id: Int
    let documentId: String
    let reason: String
    let hours: Int
    let date: Date
    var permissionStatus: Status
    let createdAt: Date
    let updatedAt: Date
    let publishedAt: Date
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, documentId, reason, hours, date, permissionStatus, createdAt, updatedAt, publishedAt
        case user = "users_permissions_user"
    }
}
