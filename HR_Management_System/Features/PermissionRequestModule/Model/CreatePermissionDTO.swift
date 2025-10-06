//
//  CreatePermissionDTO.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

struct CreatePermissionDTO: Encodable {
    
    let reason: String
    let hours: Int
    let date: String          // "yyyy-MM-dd"
}
