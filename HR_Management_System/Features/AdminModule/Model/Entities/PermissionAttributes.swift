//
//  PermissionAttributes.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

struct PermissionAttributes: Decodable {
    let reason: String
    let hours: Int
    let date: Date
    let status: Status
    let employeeId: Int
}
