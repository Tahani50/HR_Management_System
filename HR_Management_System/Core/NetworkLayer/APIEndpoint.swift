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
    case pendingLeaves(query: [URLQueryItem] = [])
    case updatePermissionStatus(id: Int)
    case updateLeaveStatus(id: Int)
    case allAttendance(query: [URLQueryItem] = [])        // ✅ Added for Admin view

    // MARK: base
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

    // Whether the body must be wrapped as { "data": ... } (Strapi v4)
    var requiresStrapiDataWrapper: Bool {
        switch self {
        case .login: return false
        default:     return true
        }
    }

    // Compose URL (⚠️ paths below DO NOT start with "/")
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
                    URLQueryItem(name: "sort", value: "date:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )

        case let .pendingLeaves(query):
            return APIEndpoint.url(
                "api/leave-requests",
                baseQuery: [
                    URLQueryItem(name: "sort", value: "dateFrom:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )

        case let .updatePermissionStatus(id):
            return APIEndpoint.base.appendingPathComponent("api/permission-requests/\(id)").absoluteString

        case let .updateLeaveStatus(id):
            return APIEndpoint.base.appendingPathComponent("api/leave-requests/\(id)").absoluteString

        case let .allAttendance(query):
            return APIEndpoint.url(
                "api/attendances",
                baseQuery: [
                    URLQueryItem(name: "sort", value: "timestamp:desc"),
                    URLQueryItem(name: "pagination[pageSize]", value: "100")
                ],
                extra: query
            )
        }
    }

    // Helper to build URLs with query items (expects path with NO leading “/”)
    private static func url(_ path: String, baseQuery: [URLQueryItem], extra: [URLQueryItem]) -> String {
        var comps = URLComponents(url: APIEndpoint.base.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        // ✅ drop any populate=employee if it sneaks in
        let safeExtra = extra.filter { !($0.name == "populate" && $0.value == "employee") }
        comps.queryItems = baseQuery + safeExtra
        return comps.string!
    }
}

enum StrapiFilter {
    // filters[employee][id][$eq]=<userId>
    static func employeeIdEq(_ userId: Int) -> URLQueryItem {
        URLQueryItem(name: "filters[employee][id][$eq]", value: "\(userId)")
    }
}
