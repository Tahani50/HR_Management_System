//
//  PermissionResponse.swift
//  HR_Management_System
//
//  Created by Naif on 16/04/1447 AH.
//


import Foundation

struct PermissionResponse: Codable {
    let data: PermissionDataResponse
    let meta: MetaResponse?
}

struct PermissionDataResponse: Codable {
    let id: Int
    let documentId: String
    let reason: String
    let hours: Int
    let date: String
    let permissionStatus: String
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
}

struct MetaResponse: Codable {}

struct PermissionRequest: Encodable {
    let reason: String
    let hours: Int
    let date: String

}
