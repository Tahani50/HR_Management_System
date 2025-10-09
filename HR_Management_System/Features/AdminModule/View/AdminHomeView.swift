//
//  AdminHomeView.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import SwiftUI

struct AdminHomeView: View {
    
    let user: User
    @StateObject private var vm = AdminHomeViewModel()
    @ObservedObject var vmL: LoginViewModel
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.12).ignoresSafeArea()
            
            VStack(spacing: 12) {
                
                Text("Hello, \(user.displayName ?? user.username)")
                    .font(.largeTitle).bold()
                    .padding(.top, 8)
                
                if vm.isLoading { ProgressView("Loading...").padding() }
                if let err = vm.errorMessage {
                    Text(err).foregroundColor(.red).padding(.horizontal)
                }
                
                List {
                    Section("Permissions List") {
                        
                        if vm.permissions.isEmpty {
                            
                            Text("No permissions")
                                .foregroundColor(.secondary)
                            
                        } else {
                            ForEach(vm.permissions) { row in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(row.user?.displayName ?? row.user?.username ?? "Employee").bold()
                                        Spacer()
                                        statusBadge(row.permissionStatus)
                                    }
                                    Text("Reason: \(row.reason)")
                                    Text("Hours: \(row.hours) • Date: \(format(date: row.date))")
                                        .bold()
                                        .font(.caption).foregroundColor(.secondary)
                                    
                                    HStack {
                                        Button("Approve") {
                                            Task {
                                                await vm.updatePermissionStatus(row, status: .approved)
                                            }
                                        }
                                        .buttonStyle(.borderedProminent)
                                        Button("Reject") {
                                            Task {
                                                await vm.updatePermissionStatus(row, status: .rejected)
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    Section("Leaves List") {
                        
                        if vm.leaves.isEmpty {
                            
                            Text("No leaves")
                                .foregroundColor(.secondary)
                            
                        } else {
                            ForEach(vm.leaves) { row in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(row.user?.displayName ?? row.user?.username ?? "Employee").bold()
                                        Spacer()
                                        statusBadge(row.leaveStatus)
                                    }
                                    Text("Type: \(row.type.rawValue.capitalized)")
                                    Text("From: \(format(dateString: row.dateFrom))"
                                         + "  To: \(format(dateString: row.dateTo))")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Button("Approve") {
                                            Task {
                                                await vm.updateLeaveStatus(row, status: .approved)
                                            }
                                        }
                                        .buttonStyle(.borderedProminent)
                                        Button("Reject") {
                                            Task {
                                                await vm.updateLeaveStatus(row, status: .rejected)
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    Section("Attendance List") {
                        if vm.attendance.isEmpty {
                            Text("No attendance records")
                                .foregroundColor(.secondary)
                        } else {
                            let records = vm.attendance.sorted { $0.timestamp < $1.timestamp }

                            if let first = records.first, let user = first.user {
                                VStack(alignment: .leading, spacing: 12) {

                                    HStack(spacing: 4) {
                                        Text(user.displayName ?? "Employee")
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        Text(first.timestamp, style: .date)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    HStack {
                                        ForEach(records.indices, id: \.self) { index in
                                            HStack(alignment: .firstTextBaseline) {
                                                Text(records[index].actionText + ":")
                                                    .bold()
                                                Text(records[index].timestamp.formatted(date: .omitted, time: .shortened))
                                            }
                                            
                                            if index != records.count - 1 {
                                                Spacer()
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .font(.body)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    Button("Logout") { vmL.logout() }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .task {
            await vm.loadAll()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Small helpers
    
    private func statusBadge(_ status: Status) -> some View {
        let color: Color = {
            switch status {
            case .approved: return .green
            case .rejected: return .red
            default: return .orange
            }
        }()
        return Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
    private func format(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
    
    private func format(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: dateString) {
            return formatter.string(from: date)
        }
        return dateString
    }
}

extension Attendance {
    var actionText: String {
        switch action {
        case .sign_in:  return "Sign in"
        case .sign_out: return "Sign out"
        }
    }
}
