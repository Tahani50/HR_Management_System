//
//  Leave.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct Leave: Codable, Identifiable {
    
    let id: Int
    let documentId: String
    let type: LeaveType
    let dateFrom: String
    let dateTo: String
    var leaveStatus: Status
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, documentId, type, dateFrom, dateTo, leaveStatus, createdAt, updatedAt, publishedAt
        case user = "users_permissions_user"
    }
}
