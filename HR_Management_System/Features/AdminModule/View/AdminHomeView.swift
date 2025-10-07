//
//  AdminHomeView.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import SwiftUI

struct AdminHomeView: View {
    
    @StateObject private var vm = AdminHomeViewModel()
    @ObservedObject var vmL: LoginViewModel
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.12).ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Hello, \(vm.adminName)")
                    .font(.largeTitle).bold()
                    .padding(.top, 8)

                if vm.isLoading { ProgressView("Loading...").padding() }
                if let err = vm.errorMessage {
                    Text(err).foregroundColor(.red).padding(.horizontal)
                }

                List {
                    Section("Permissions (Pending)") {
                        if vm.permissions.isEmpty {
                            Text("No pending permissions").foregroundColor(.secondary)
                        } else {
                            ForEach(vm.permissions) { row in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(row.employeeName).bold()
                                        Spacer()
                                        statusBadge(row.request.status)
                                    }
                                    Text("Reason: \(row.request.reason)")
                                    Text("Hours: \(row.request.hours) • Date: \(format(date: row.request.date))")
                                        .font(.caption).foregroundColor(.secondary)

                                    HStack {
                                        Button("Approve") { vm.approvePermission(row) }
                                            .buttonStyle(.borderedProminent)
                                        Button("Reject") { vm.rejectPermission(row) }
                                            .buttonStyle(.bordered)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    Section("Leaves (Pending)") {
                        if vm.leaves.isEmpty {
                            Text("No pending leaves").foregroundColor(.secondary)
                        } else {
                            ForEach(vm.leaves) { row in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(row.employeeName).bold()
                                        Spacer()
                                        statusBadge(row.request.status)
                                    }
                                    Text("Type: \(row.request.type.rawValue.capitalized)")
                                    Text("From: \(format(date: row.request.dateFrom))"
                                         + (row.request.dateTo != nil ? "  To: \(format(date: row.request.dateTo!))" : ""))
                                        .font(.caption).foregroundColor(.secondary)

                                    HStack {
                                        Button("Approve") { vm.approveLeave(row) }
                                            .buttonStyle(.borderedProminent)
                                        Button("Reject") { vm.rejectLeave(row) }
                                            .buttonStyle(.bordered)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    Section("Attendance (All)") {
                        if vm.attendance.isEmpty {
                            Text("No attendance records").foregroundColor(.secondary)
                        } else {
                            ForEach(vm.attendance) { row in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(row.employeeName).bold()
                                        Text(format(dateTime: row.attendance.timestamp))
                                            .font(.caption).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(row.attendance.action.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
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
        .onAppear { vm.loadAll() }
        .navigationTitle("Admin Home")
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

    private func format(dateTime: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f.string(from: dateTime)
    }
}
