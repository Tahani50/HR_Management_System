//
//  AttendanceAttributes.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//


import Foundation

struct AttendanceAttributes: Decodable {
    let timestamp: Date
    let action: AttendanceAction
    let employeeId: Int
}
