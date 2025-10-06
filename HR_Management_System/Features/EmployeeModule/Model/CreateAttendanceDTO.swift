//
//  CreateAttendanceDTO.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct CreateAttendanceDTO: Encodable {
    
    let timestamp: String     // ISO8601
    let action: AttendanceAction
}
