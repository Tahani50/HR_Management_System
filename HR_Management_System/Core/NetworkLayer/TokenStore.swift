//
//  TokenStore.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//


import Foundation

final class TokenStore {
    static let shared = TokenStore()
    private init() {}
    var accessToken: String?        // set on login
}