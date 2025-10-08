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
    let users_permissions_user: UserSlim?   // 👈 populated user (object)
}

enum UserRelation: Decodable {
    case one(UserSlim), many([UserSlim]), none
    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() { self = .none; return }
        if let one = try? c.decode(UserSlim.self) { self = .one(one); return }
        if let many = try? c.decode([UserSlim].self) { self = .many(many); return }
        self = .none
    }
    var first: UserSlim? { switch self { case .one(let u): u; case .many(let a): a.first; case .none: nil } }
}

struct UserSlim: Decodable, Identifiable {
    let id: Int
    let username: String?
    let displayName: String?
    let email: String?
}
