//
//  LeaveAttributes.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

struct LeaveAttributes: Decodable {
    let type: LeaveType
    let dateFrom: Date
    let dateTo: Date?
    let status: Status
    let employeeId: Int
}
