//
//  AdminServiceProtocol.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

protocol AdminServiceProtocol {
    func fetchPendingPermissions() async throws -> [PermissionRequestRow]
    func fetchPendingLeaves() async throws -> [LeaveRequestRow]
    func fetchAllAttendance() async throws -> [AttendanceRow]
    func updatePermissionStatus(id: Int, to status: Status) async throws
    func updateLeaveStatus(id: Int, to status: Status) async throws
}

// Row models for easy rendering (include employeeName for UI)
struct PermissionRequestRow: Identifiable, Equatable {
    let id: Int
    let request: PermissionRequest2
    let employeeName: String
}

struct LeaveRequestRow: Identifiable, Equatable {
    let id: Int
    let request: LeaveRequest
    let employeeName: String
}

struct AttendanceRow: Identifiable, Equatable {
    let id: Int
    let attendance: Attendance
    let employeeName: String
}
