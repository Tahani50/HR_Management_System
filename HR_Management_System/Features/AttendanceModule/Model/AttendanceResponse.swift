//
//  AttendanceResponse.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct AttendanceResponse: Codable {
    
    let data: [Attendance]
    let meta: Meta
}
