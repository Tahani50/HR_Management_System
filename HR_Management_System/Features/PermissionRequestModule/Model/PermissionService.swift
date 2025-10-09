//
//  PermissionService.swift
//  HR_Management_System
//
//  Created by Naif on 16/04/1447 AH.
//


import Foundation

final class PermissionService: PermissionServiceProtocol {
    
    func createPermission(_ request: PermissionRequest) async throws -> PermissionResponse {
        try await NetworkManager.shared.request(endpoint: .createPermission, body: request)
    }
}
