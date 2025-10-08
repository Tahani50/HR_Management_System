//
//  APIEndpoint.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

enum APIEndpoint {
    
    case login
    case myPermissionRequests(userId: Int, query: [URLQueryItem] = [])
    case myLeaveRequests(userId: Int, query: [URLQueryItem] = [])
    case myAttendance(userId: Int, query: [URLQueryItem] = [])
    case createPermission
    case createLeave
    case createAttendance
    case pendingPermissions(query: [URLQueryItem] = [])
    case updatePermissionStatus(id: Int)
    case pendingLeaves(query: [URLQueryItem] = [])
    case updateLeaveStatus(id: Int)
    case allAttendance(query: [URLQueryItem] = [])
    static let base = URL(string: "http://localhost:1337")!
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .myPermissionRequests, .myLeaveRequests, .myAttendance,
                .pendingPermissions, .pendingLeaves, .allAttendance: return .get
        case .createPermission, .createLeave, .createAttendance: return .post
        case .updatePermissionStatus, .updateLeaveStatus: return .put
        }
    }
    
    var requiresStrapiDataWrapper: Bool {
        switch self {
        case .login: return false
        case .pendingPermissions, .pendingLeaves, .allAttendance: return false
        default:     return true
        }
    }
    
    var url: String {
        switch self {
            
        case .login:
            return APIEndpoint.base.appendingPathComponent("api/auth/local").absoluteString
            
        case let .myPermissionRequests(userId, query):
            return APIEndpoint.url(
                "api/permission-requests",
                baseQuery: [
                    StrapiFilter.employeeIdEq(userId),
                    URLQueryItem(name: "sort", value: "date:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )
            
        case let .myLeaveRequests(userId, query):
            return APIEndpoint.url(
                "api/leave-requests",
                baseQuery: [
                    StrapiFilter.employeeIdEq(userId),
                    URLQueryItem(name: "sort", value: "dateFrom:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )
            
        case let .myAttendance(userId, query):
            return APIEndpoint.url(
                "api/attendances",
                baseQuery: [
                    StrapiFilter.employeeIdEq(userId),
                    URLQueryItem(name: "sort", value: "timestamp:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )
            
        case .createPermission:
            return APIEndpoint.base.appendingPathComponent("api/permission-requests").absoluteString
            
        case .createLeave:
            return APIEndpoint.base.appendingPathComponent("api/leave-requests").absoluteString
            
        case .createAttendance:
            return APIEndpoint.base.appendingPathComponent("api/attendances").absoluteString
            
        case let .pendingPermissions(query):
            return APIEndpoint.url(
                "api/permission-requests",
                baseQuery: [
                    URLQueryItem(name: "populate", value: "users_permissions_user"), // ✅ keep this
                    URLQueryItem(name: "sort", value: "date:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )
            
        case let .pendingLeaves(query):
            return APIEndpoint.url(
                "api/leave-requests",
                baseQuery: [
                    // optional populate if you have the same relation on Leave
                    URLQueryItem(name: "populate", value: "users_permissions_user"),
                    URLQueryItem(name: "sort", value: "dateFrom:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )
            
        case let .updatePermissionStatus(id):
            return APIEndpoint.base
                .appendingPathComponent("api/permission-requests")
                .appendingPathComponent("\(id)")
                .absoluteString
            
        case let .updateLeaveStatus(id):
            return APIEndpoint.base.appendingPathComponent("api/leave-requests/\(id)").absoluteString
            
        case let .allAttendance(query):
            return APIEndpoint.url(
                "api/attendances",
                baseQuery: [
                    URLQueryItem(name: "populate", value: "users_permissions_user"), // ⬅️ get the user name
                    URLQueryItem(name: "sort", value: "timestamp:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query   // keep this empty to avoid duplicate sort in logs
            )
            
        }
    }
    
    // Helper to build URLs with query items (expects path with NO leading “/”)
    private static func url(_ path: String, baseQuery: [URLQueryItem], extra: [URLQueryItem]) -> String {
        var comps = URLComponents(url: APIEndpoint.base.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        comps.queryItems = baseQuery + extra
        return comps.string!
    }
}

enum StrapiFilter {
    // filters[employee][id][$eq]=<userId>
    static func employeeIdEq(_ userId: Int) -> URLQueryItem {
        URLQueryItem(name: "filters[employee][id][$eq]", value: "\(userId)")
    }
}
