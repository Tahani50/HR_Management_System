//
//  Attendance.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct Attendance: Codable, Identifiable {
    
    let id: Int
    let documentId: String
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let timestamp: Date
    let action: AttendanceAction
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, documentId, timestamp, action, createdAt, updatedAt, publishedAt
        case user = "users_permissions_user"
    }
}
