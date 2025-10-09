//
//  AdminService.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

final class AdminService: AdminServiceProtocol {
    func fetchPendingPermissions() async throws -> [PermissionRequestRow] {
        let list: StrapiFlatList<PermissionFlat> =
        try await NetworkManager.shared.request(endpoint: .pendingPermissions())
        
        let rows: [PermissionRequestRow] = list.data.map { flat in
            let user = flat.users_permissions_user
            let empId = user?.id ?? 0
            let name  = user?.displayName ?? user?.username ?? (empId > 0 ? "Employee #\(empId)" : "Employee")
            
            let model = PermissionRequest2(
                id: flat.id,
                reason: flat.reason,
                hours: flat.hours,
                date: flat.date,
                status: flat.permissionStatus,
                employeeId: empId
            )
            return PermissionRequestRow(id: flat.id, request: model, employeeName: name)
        }
        
        return rows.filter { $0.request.status == .pending }
    }
    
    func updatePermissionStatus(id: Int, to status: Status) async throws {
        // PUT /api/permission-requests/:id with { "data": { "permissionStatus": "approved" } }
        let body = UpdatePermissionStatusDTO(permissionStatus: status)
        struct EmptyOK: Decodable {}
        _ = try await NetworkManager.shared.request(
            endpoint: .updatePermissionStatus(id: id),
            body: body
        ) as EmptyOK
    }
    
    
    func fetchPendingLeaves() async throws -> [LeaveRequestRow] {
        let list: StrapiFlatList<LeaveFlat> =
        try await NetworkManager.shared.request(endpoint: .pendingLeaves())
        
        let rows: [LeaveRequestRow] = list.data.map { flat in
            let empId = flat.users_permissions_user?.id ?? 0
            let name  = flat.users_permissions_user?.displayName
            ?? flat.users_permissions_user?.username
            ?? (empId > 0 ? "Employee #\(empId)" : "Employee")
            
            let model = LeaveRequest(
                id: flat.id,
                type: flat.type,
                dateFrom: flat.dateFrom,
                dateTo: flat.dateTo,
                status: flat.leaveStatus,   // <- matches your raw JSON
                employeeId: empId
            )
            return LeaveRequestRow(id: flat.id, request: model, employeeName: name)
        }
        
        return rows.filter { $0.request.status == .pending }
    }
    
    func fetchAllAttendance() async throws -> [AttendanceRow] {
            let list: StrapiFlatList<AttendanceFlat> =
                try await NetworkManager.shared.request(endpoint: .allAttendance())

            return list.data.map { flat in
                let empId = flat.users_permissions_user?.id ?? 0
                let name  = flat.users_permissions_user?.displayName
                        ?? flat.users_permissions_user?.username
                        ?? (empId > 0 ? "Employee #\(empId)" : "Employee")

                let model = Attendance(
                    id: flat.id,
                    timestamp: flat.timestamp,
                    action: flat.action,
                    employeeId: empId
                )
                return AttendanceRow(id: flat.id, attendance: model, employeeName: name)
            }
        }
    
    func updateLeaveStatus(id: Int, to status: Status) async throws {
        let _: StrapiSingle<LeaveAttributes> = try await NetworkManager.shared.request(
            endpoint: .updateLeaveStatus(id: id),
            body: UpdateStatusDTO(status: status)
        )
    }
    
    // MARK: - Mappers
    
    private func mapPermission(_ e: StrapiEntity<PermissionAttributes>) -> PermissionRequestRow {
        let empId = e.attributes.employeeId
        let model = PermissionRequest2(
            id: e.id,
            reason: e.attributes.reason,
            hours: e.attributes.hours,
            date: e.attributes.date,
            status: e.attributes.status,
            employeeId: empId
        )
        return .init(id: e.id, request: model, employeeName: "Employee #\(empId)")
    }
    
    private func mapLeave(_ e: StrapiEntity<LeaveAttributes>) -> LeaveRequestRow {
        let empId = e.attributes.employeeId
        let model = LeaveRequest(
            id: e.id,
            type: e.attributes.type,
            dateFrom: e.attributes.dateFrom,
            dateTo: e.attributes.dateTo,
            status: e.attributes.status,
            employeeId: empId
        )
        return .init(id: e.id, request: model, employeeName: "Employee #\(empId)")
    }
    
    private func mapAttendance(_ e: StrapiEntity<AttendanceAttributes>) -> AttendanceRow {
        let empId = e.attributes.employeeId
        let model = Attendance(
            id: e.id,
            timestamp: e.attributes.timestamp,
            action: e.attributes.action,
            employeeId: empId
        )
        return .init(id: e.id, attendance: model, employeeName: "Employee #\(empId)")
    }
}
