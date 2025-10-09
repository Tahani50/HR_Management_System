//
//  AdminServiceProtocol.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

protocol AdminServiceProtocol {
    
    func fetchPermissions() async throws -> [Permission]
    func fetchLeaves() async throws -> [Leave]
    func fetchAttendance() async throws -> [Attendance]
    func updatePermissionStatus(documentId: String, status: Status) async throws -> Permission
    func updateLeaveStatus(documentId: String, status: Status) async throws -> Leave
}
