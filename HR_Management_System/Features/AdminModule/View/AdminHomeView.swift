//
//  AdminHomeView.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import SwiftUI

struct AdminHomeView: View {
    
    let user: User
    @ObservedObject var vm: LoginViewModel
    
    var body: some View {
        
        ZStack {
            Color(user.theme.backgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Hello, \(user.displayName ?? user.username)")
                    .font(.title2).bold()
                
                Text("Permissions List").font(.headline)
                // list of pending permissions...
                
                Text("Leaves List").font(.headline)
                // list of pending leaves...
                
                Text("Attendance Summary").font(.headline)
                // attendance summary...
            }
            .padding()
        }
        .navigationTitle("Admin Home")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Logout") { vm.logout() }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
