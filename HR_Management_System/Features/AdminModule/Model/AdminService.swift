//
//  AdminService.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//

import Foundation

final class AdminService: AdminServiceProtocol {
    func fetchPendingPermissions() async throws -> [PermissionRequestRow] {
            // Decode the flat response
            let list: StrapiFlatList<PermissionFlat> =
                try await NetworkManager.shared.request(endpoint: .pendingPermissions())

            // Map to your existing UI rows, then filter pending
            let rows: [PermissionRequestRow] = list.data.map { flat in
                // Use 0 if employeeId is not present in the payload yet
                let empId = 0

                let model = PermissionRequest(
                    id: flat.id,
                    reason: flat.reason,
                    hours: flat.hours,
                    date: flat.date,
                    status: flat.permissionStatus,   // <-- key change
                    employeeId: empId
                )

                // Show a simple placeholder name for now
                return PermissionRequestRow(
                    id: flat.id,
                    request: model,
                    employeeName: "Employee"
                )
            }

            return rows.filter { $0.request.status == .pending }
        }



    func fetchPendingLeaves() async throws -> [LeaveRequestRow] {
        let list: StrapiList<LeaveAttributes> =
            try await NetworkManager.shared.request(endpoint: .pendingLeaves())
        let rows = list.data.map { mapLeave($0) }
        return rows.filter { $0.request.status == .pending }
    }

    func fetchAllAttendance() async throws -> [AttendanceRow] {
        // GET /api/attendances?populate=employee&sort=timestamp:desc
        let list: StrapiList<AttendanceAttributes> = try await NetworkManager.shared.request(
            endpoint: .allAttendance(
                query: [
                    URLQueryItem(name: "sort", value: "timestamp:desc")
                ]
            )
        )
        return list.data.map { mapAttendance($0) }
    }

    func updatePermissionStatus(id: Int, to status: Status) async throws {
        let body = UpdatePermissionStatusDTO(permissionStatus: status)
        // Reuses your NetworkManager’s {data: ...} wrapper automatically
        let _: StrapiSingle<PermissionAttributes> = try await NetworkManager.shared.request(
            endpoint: .updatePermissionStatus(id: id),
            body: body
        )
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
        let model = PermissionRequest(
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
