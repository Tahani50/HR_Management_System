//
//  LeaveRequest.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct LeaveRequest: Identifiable, Codable, Equatable {
    
    let id: Int
    var type: LeaveType
    var dateFrom: Date        // yyyy-MM-dd
    var dateTo: Date?         // yyyy-MM-dd
    var status: Status
    var employeeId: Int       // owner
}
