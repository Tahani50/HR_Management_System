//
//  PermissionResponse.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct PermissionResponse: Codable {
    
    let data: [Permission]
    let meta: Meta
}
