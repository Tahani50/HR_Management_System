//
//  StrapiList.swift
//  HR_Management_System
//
//  Created by Tahani on 15/04/1447 AH.
//


import Foundation

// Generic list: { "data": [ { id, attributes: {...} }, ... ] }
struct StrapiList<T: Decodable>: Decodable {
    let data: [StrapiEntity<T>]
}

// Generic single: { "data": { id, attributes: {...} } }
struct StrapiSingle<T: Decodable>: Decodable {
    let data: StrapiEntity<T>
}

// { "id": 1, "attributes": {...} }
struct StrapiEntity<T: Decodable>: Decodable {
    let id: Int
    let attributes: T
}

// Relations: { "data": { id, attributes: {...} } } or null
struct RelationRef<T: Decodable>: Decodable {
    let data: StrapiEntity<T>?
}

// Keep employee flexible (maybe name or username in your Strapi)
struct EmployeeAttributes: Decodable {
    let name: String?
    let username: String?
}

// Matches: { "data": [ {...}, ... ], "meta": {...} }
struct StrapiFlatList<T: Decodable>: Decodable {
    let data: [T]
}

// Matches one permission row in your raw JSON
// {"id":2,"reason":"...","hours":2,"date":"2025-10-07T10:00:00.000Z","permissionStatus":"pending", ...}
struct PermissionFlat: Decodable, Identifiable {
    let id: Int
    let reason: String
    let hours: Int
    let date: Date
    let permissionStatus: Status

    // If your payload later includes employeeId, add it here:
    // let employeeId: Int?
}
