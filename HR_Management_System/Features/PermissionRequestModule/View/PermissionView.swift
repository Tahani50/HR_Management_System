//
//  PermissionView.swift
//  HR_Management_System
//
//  Created by Naif on 16/04/1447 AH.
//


import SwiftUI

struct PermissionView: View {
    
    @StateObject private var vm = PermissionViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Permission Details") {
                    TextField("Reason", text: $vm.reason)
                    Stepper("Hours: \(vm.hours)", value: $vm.hours, in: 1...8)
                    DatePicker("Date", selection: $vm.date, displayedComponents: .date)
                }
                
                Section {
                    Button {
                        Task {
                            await vm.submitPermission()
                        }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            Text("Submit Permission")
                        }
                    }
                    .disabled(vm.reason.isEmpty || vm.isLoading)
                }
                
                if let created = vm.createdPermission {
                    Section("Created Permission") {
                        Text("ID: \(created.id)")
                        Text("Reason: \(created.reason)")
                        Text("Hours: \(created.hours)")
                        Text("Date: \(created.date)")
                        Text("Status: \(created.permissionStatus)")
                    }
                }
                
                if let error = vm.errorMessage {
                    Section {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Permission")
        }
    }
}
