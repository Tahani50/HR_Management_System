//
//  Theme.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation
import SwiftUI

enum Theme: String, Codable, CaseIterable {
    case lightBlue, red
}

extension Theme {
    var backgroundColor: Color {
        switch self {
        case .lightBlue: return Color(red: 0.90, green: 0.96, blue: 1.0)
        case .red:       return Color(red: 1.00, green: 0.93, blue: 0.93)
        }
    }
    var accentColor: Color { self == .lightBlue ? .blue : .red }
}
