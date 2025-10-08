//
//  AttendanceFlat.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct AttendanceFlat: Decodable, Identifiable {
    
    let id: Int
    let timestamp: Date              // Strapi sends ISO8601; your NetworkManager decodes it
    let action: AttendanceAction
    let users_permissions_user: UserSlim?   // populated user (same model you already have)
}
