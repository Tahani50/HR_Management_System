//
//  UpdatePermissionRequest.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct UpdatePermissionRequest: Codable {
    
    let data: PermissionStatusData
}

struct PermissionStatusData: Codable {
    
    let permissionStatus: String
}
