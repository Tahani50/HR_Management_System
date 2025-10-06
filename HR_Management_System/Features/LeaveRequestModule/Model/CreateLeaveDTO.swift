//
//  CreateLeaveDTO.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct CreateLeaveDTO: Encodable {
    
    let type: LeaveType
    let dateFrom: String      // "yyyy-MM-dd"
    let dateTo: String?       // "yyyy-MM-dd"
}
