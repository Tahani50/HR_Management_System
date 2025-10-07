//
//  Attendance.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct Attendance: Identifiable, Codable, Equatable {
    
    let id: Int
    var timestamp: Date       // ISO8601 datetime
    var action: AttendanceAction
    var employeeId: Int       // owner
}
