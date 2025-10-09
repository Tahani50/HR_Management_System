//
//  PermissionRequest.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct PermissionRequest2: Identifiable, Codable, Equatable {

    let id: Int
    var reason: String
    var hours: Int
    var date: Date            // yyyy-MM-dd
    var status: Status
    var employeeId: Int       // owner
}
