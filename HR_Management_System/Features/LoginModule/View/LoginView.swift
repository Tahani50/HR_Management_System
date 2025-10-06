//
//  LoginView.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()

    var body: some View {
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
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Login").frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.email.isEmpty || vm.password.isEmpty || vm.isLoading)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red).font(.footnote).multilineTextAlignment(.center)
            }

            if let resp = vm.loginResponse {
                // Example success preview (you can navigate instead)
                Text("Welcome, \(resp.user.displayName ?? resp.user.username)")
                    .foregroundColor(.green)
                    .font(.footnote)
            }
        }
        .padding()
    }
}
