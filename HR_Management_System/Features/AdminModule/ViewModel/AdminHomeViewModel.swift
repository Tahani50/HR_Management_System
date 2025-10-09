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
    
    @Published var permissions: [Permission] = []
    @Published var leaves: [Leave] = []
    @Published var attendance: [Attendance] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: AdminServiceProtocol
    
    init(service: AdminServiceProtocol = AdminService()) {
        self.service = service
    }
    
    func loadAll() async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            let permissions = try await service.fetchPermissions()
            self.permissions = permissions.sorted { $0.createdAt > $1.createdAt }
            
            let leaves = try await service.fetchLeaves()
            self.leaves = leaves.sorted { $0.createdAt > $1.createdAt }
            
            let attendance = try await service.fetchAttendance()
            self.attendance = attendance
            
            self.errorMessage = nil
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func updatePermissionStatus(_ permission: Permission, status: Status) async {
        
        guard let idx = permissions.firstIndex(where: { $0.documentId == permission.documentId }) else { return }
        let old = permissions[idx]
        var optimistic = old
        optimistic.permissionStatus = status
        permissions[idx] = optimistic
        
        do {
            let updated = try await service.updatePermissionStatus(documentId: permission.documentId, status: status)
            permissions[idx] = updated
            permissions.sort { $0.createdAt > $1.createdAt }
            errorMessage = nil
        } catch {
            permissions[idx] = old
            errorMessage = error.localizedDescription
        }
    }
    
    func updateLeaveStatus(_ leave: Leave, status: Status) async {
        
        guard let idx = leaves.firstIndex(where: { $0.documentId == leave.documentId }) else { return }
        let old = leaves[idx]
        var optimistic = old
        optimistic.leaveStatus = status
        leaves[idx] = optimistic
        
        do {
            let updated = try await service.updateLeaveStatus(documentId: leave.documentId, status: status)
            leaves[idx] = updated
            leaves.sort { $0.createdAt > $1.createdAt }
            errorMessage = nil
        } catch {
            leaves[idx] = old
            errorMessage = error.localizedDescription
        }
    }
}
