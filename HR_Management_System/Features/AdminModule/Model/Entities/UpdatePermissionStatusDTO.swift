//
//  UpdatePermissionStatusDTO.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

struct UpdatePermissionStatusDTO: Encodable {
    
    let permissionStatus: Status
}

struct UpdateLeaveStatusDTO: Encodable {
    
    let leaveStatus: Status
}
