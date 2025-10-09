//
//  AdminService.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

final class AdminService: AdminServiceProtocol {
    
    func fetchPermissions() async throws -> [Permission] {
        let response: PermissionResponse = try await NetworkManager.shared.request(
            endpoint: .permissionRequests
        )
        return response.data
    }
    
    func fetchLeaves() async throws -> [Leave] {
        let response: LeaveResponse = try await NetworkManager.shared.request(
            endpoint: .leaveRequests
        )
        return response.data
    }
    
    func fetchAttendance() async throws -> [Attendance] {
        let response: AttendanceResponse = try await NetworkManager.shared.request(
            endpoint: .attendance
        )
        return response.data
    }
    
    func updatePermissionStatus(documentId: String, status: Status) async throws -> Permission {
        let body = UpdatePermissionRequest(data: .init(permissionStatus: status.rawValue))
        let response: UpdatePermissionResponse = try await NetworkManager.shared.request(
            endpoint: .updatePermissionStatus(documentId: documentId),
            body: body
        )
        return response.data
    }
    
    func updateLeaveStatus(documentId: String, status: Status) async throws -> Leave {
        let body = UpdateLeaveRequest(data: .init(leaveStatus: status.rawValue))
        let response: UpdateLeaveResponse = try await NetworkManager.shared.request(
            endpoint: .updateLeaveStatus(documentId: documentId),
            body: body
        )
        return response.data
    }
}
