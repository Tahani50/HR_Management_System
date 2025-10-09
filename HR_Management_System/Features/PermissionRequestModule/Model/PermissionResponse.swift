//
//  PermissionResponse.swift
//  HR_Management_System
//
//  Created by Naif on 16/04/1447 AH.
//


import Foundation

// MARK: - رد السيرفر عند استعلام إذن
struct PermissionResponse: Codable {
    let data: PermissionDataResponse
    let meta: MetaResponse?
}

// MARK: - بيانات الإذن في الرد
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

// MARK: - ميتا (فارغة حالياً)
struct MetaResponse: Codable {}

// MARK: - نموذج إرسال الطلب لإنشاء إذن
struct PermissionRequest: Encodable {
    let reason: String
    let hours: Int
    let date: String // التنسيق: "yyyy-MM-dd"
}
