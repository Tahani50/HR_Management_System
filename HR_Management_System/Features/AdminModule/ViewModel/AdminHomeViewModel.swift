//
//  AdminHomeViewModel.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation
import Combine

@MainActor
final class AdminHomeViewModel: ObservableObject {
    
    @Published var adminName: String = "Admin"
    @Published var permissions: [PermissionRequestRow] = []
    @Published var leaves: [LeaveRequestRow] = []
    @Published var attendance: [AttendanceRow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: AdminServiceProtocol

    init(service: AdminServiceProtocol = AdminService()) {
        self.service = service
    }

    func loadAll() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                async let p = service.fetchPendingPermissions()
                async let l = service.fetchPendingLeaves()
                async let a = service.fetchAllAttendance()
                (permissions, leaves, attendance) = try await (p, l, a)
            } catch {
                errorMessage = "Failed to load. Check Strapi URL/roles/token."
            }
        }
    }

    func approvePermission(_ row: PermissionRequestRow) {
        updatePermission(row, to: .approved)
    }

    func rejectPermission(_ row: PermissionRequestRow) {
        updatePermission(row, to: .rejected)
    }

    private func updatePermission(_ row: PermissionRequestRow, to status: Status) {
        Task {
            do {
                try await service.updatePermissionStatus(id: row.id, to: status)
                if let i = permissions.firstIndex(where: { $0.id == row.id }) {
                    var updated = permissions[i]
                    var req = updated.request
                    req.status = status
                    updated = PermissionRequestRow(id: updated.id, request: req, employeeName: updated.employeeName)
                    permissions[i] = updated
                }
            } catch {
                errorMessage = "Could not update permission."
            }
        }
    }

    func approveLeave(_ row: LeaveRequestRow) {
        updateLeave(row, to: .approved)
    }

    func rejectLeave(_ row: LeaveRequestRow) {
        updateLeave(row, to: .rejected)
    }

    private func updateLeave(_ row: LeaveRequestRow, to status: Status) {
        Task {
            do {
                try await service.updateLeaveStatus(id: row.id, to: status)
                if let i = leaves.firstIndex(where: { $0.id == row.id }) {
                    var updated = leaves[i]
                    var req = updated.request
                    req.status = status
                    updated = LeaveRequestRow(id: updated.id, request: req, employeeName: updated.employeeName)
                    leaves[i] = updated
                }
            } catch {
                errorMessage = "Could not update leave."
            }
        }
    }
}
