//
//  PermissionViewModel.swift
//  HR_Management_System
//
//  Created by Naif on 16/04/1447 AH.
//


import Foundation
import SwiftUI
import Combine

@MainActor
final class PermissionViewModel: ObservableObject {
    
    @Published var reason: String = ""
    @Published var hours: Int = 1
    @Published var date: Date = Date()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var createdPermission: PermissionDataResponse?
    
    private let service: PermissionServiceProtocol
    
    init(service: PermissionServiceProtocol = PermissionService()) {
        self.service = service
    }
    
    func submitPermission() async {
        isLoading = true
        errorMessage = nil
        createdPermission = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let request = PermissionRequest(reason: reason, hours: hours, date: dateString)
        
        do {
            let response = try await service.createPermission(request)
            createdPermission = response.data
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to create permission: \(error)")
        }
        
        isLoading = false
    }
}
