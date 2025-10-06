//
//  EmployeeHomeView.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import SwiftUI

struct EmployeeHomeView: View {
    
    let user: User
    @ObservedObject var vm: LoginViewModel
    
    var body: some View {
        
        ZStack {
            Color(user.theme.backgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Hello, \(user.displayName ?? user.username)")
                    .font(.title2).bold()
                
                Button("Permission Request") { /* navigate */ }
                    .buttonStyle(.borderedProminent).tint(user.theme.accentColor)
                
                Button("Leave Request") { /* navigate */ }
                    .buttonStyle(.borderedProminent).tint(user.theme.accentColor)
                
                HStack {
                    Button("Sign In") { /* call API */ }
                    Button("Sign Out") { /* call API */ }
                }
            }
            .padding()
        }
        .navigationTitle("Employee Home")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") { vm.logout() }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

