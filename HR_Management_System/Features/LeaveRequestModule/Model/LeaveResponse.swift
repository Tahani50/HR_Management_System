//
//  LeaveResponse.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct LeaveResponse: Codable {
    
    let data: [Leave]
    let meta: Meta
}
