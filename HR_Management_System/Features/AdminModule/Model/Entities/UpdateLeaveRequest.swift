//
//  LeaveStatusRequest.swift
//  HR_Management_System
//
//  Created by Tahani on 17/04/1447 AH.
//

import Foundation

struct UpdateLeaveRequest: Codable {
    
    let data: LeaveStatusData
}

struct LeaveStatusData: Codable {
    
    let leaveStatus: String
}
