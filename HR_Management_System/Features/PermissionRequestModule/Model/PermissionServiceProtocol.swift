//
//  PermissionServiceProtocol.swift
//  HR_Management_System
//
//  Created by Naif on 16/04/1447 AH.
//


import Foundation

protocol PermissionServiceProtocol {
    func createPermission(_ request: PermissionRequest) async throws -> PermissionResponse
}
