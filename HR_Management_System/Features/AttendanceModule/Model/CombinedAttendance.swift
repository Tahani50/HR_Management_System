//
//  CombinedAttendance.swift
//  HR_Management_System
//
//  Created by Tahani on 17/04/1447 AH.
//

import Foundation

struct CombinedAttendance: Identifiable {
    
    var id: String { "\(userDocumentId)_\(day.timeIntervalSince1970)" }
    let userDocumentId: String
    let userName: String
    let day: Date
    var signIn: Date?
    var signOut: Date?
}
