//
//  APIEndpoint.swift
//  HR_Management_System
//
//  Created by Tahani on 14/04/1447 AH.
//

import Foundation

enum APIEndpoint {
    
    case login
    case createPermission
    case createLeave
    case createAttendance
    
    case permissionRequests
    case leaveRequests
    case attendance
    
    case updatePermissionStatus(documentId: String)
    case updateLeaveStatus(documentId: String)
    
    static let base = URL(string: "http://localhost:1337")!
    static let baseURL = URL(string: "http://localhost:1337/api")!
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .attendance, .permissionRequests, .leaveRequests: return .get
        case .createPermission, .createLeave, .createAttendance: return .post
        case .updatePermissionStatus, .updateLeaveStatus: return .put
        }
    }
    
    var requiresStrapiDataWrapper: Bool {
        switch self {
        case .login: return false
        case .permissionRequests: return false
        case .leaveRequests: return false
        case .attendance: return false
        case .updatePermissionStatus: return false
        case .updateLeaveStatus: return false
        default:     return true
        }
    }
    
    var url: String {
        switch self {
            
        case .login:
            return APIEndpoint.base.appendingPathComponent("api/auth/local").absoluteString
            
            
        case .permissionRequests:
            return APIEndpoint.url("permission-requests", baseQuery: [ URLQueryItem(name: "populate", value: "users_permissions_user") ])
            
        case .leaveRequests:
            return APIEndpoint.url("leave-requests", baseQuery: [ URLQueryItem(name: "populate", value: "users_permissions_user") ])
            
        case .attendance:
            return APIEndpoint.url("attendances", baseQuery: [ URLQueryItem(name: "populate", value: "users_permissions_user") ])
            
            
        case .updatePermissionStatus(let documentId):
            return APIEndpoint.url("permission-requests/\(documentId)", baseQuery: [ URLQueryItem(name: "populate", value: "users_permissions_user") ])
            
        case .updateLeaveStatus(let documentId):
            return APIEndpoint.url("leave-requests/\(documentId)", baseQuery: [ URLQueryItem(name: "populate", value: "users_permissions_user") ])
            
        case .createPermission:
            return APIEndpoint.base.appendingPathComponent("api/permission-requests").absoluteString
            
        case .createLeave:
            return APIEndpoint.base.appendingPathComponent("api/leave-requests").absoluteString
            
        case .createAttendance:
            return APIEndpoint.base.appendingPathComponent("api/attendances").absoluteString
            
        }
    }
    
    private static func url(_ path: String, baseQuery: [URLQueryItem]) -> String {
        var comps = URLComponents(url: APIEndpoint.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        comps.queryItems = baseQuery
        return comps.string!
    }
}
