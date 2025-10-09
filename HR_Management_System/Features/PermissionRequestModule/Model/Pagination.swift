//
//  Pagination.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct Pagination: Codable {
    
    let page: Int
    let pageSize: Int
    let pageCount: Int
    let total: Int
}
