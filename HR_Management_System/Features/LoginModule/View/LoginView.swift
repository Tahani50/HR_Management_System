//
//  LoginView.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    
    // Simple route enum that carries the logged-in user
    enum Route: Hashable {
        case employee(User)
        case admin(User)
    }
    
    @State private var route: Route?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("HRMS Login").font(.largeTitle).bold()
                
                TextField("Email or Username", text: $vm.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    Task { await vm.login() }
                } label: {
                    if vm.isLoading {
                        ProgressView().progressViewStyle(.circular).frame(maxWidth: .infinity)
                    } else {
                        Text("Login").frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.email.isEmpty || vm.password.isEmpty || vm.isLoading)
                
                if let err = vm.errorMessage {
                    Text(err).foregroundColor(.red).font(.footnote).multilineTextAlignment(.center)
                }
            }
            .padding()
            // When loginResponse changes, decide the route
            .onChange(of: vm.loginResponse?.user.id) { _, _ in
                guard let user = vm.loginResponse?.user else {
                    // logout happened (vm.loginResponse == nil) → pop back
                    route = nil
                    return
                }
                route = (user.userType == .admin) ? .admin(user) : .employee(user)
            }
            // Push to destination
            .navigationDestination(item: $route) { route in
                switch route {
                case .employee(let user):
                    EmployeeHomeView(user: user, vm: vm)
                case .admin(let user):
                    AdminHomeView(vmL: vm)
                }
            }
        }
    }
}

extension LoginView.Route: Identifiable {
    var id: String {
        switch self {
        case .employee(let u): return "employee-\(u.id)"
        case .admin(let u):    return "admin-\(u.id)"
        }
    }
}
