//
//  LeaveFlat.swift
//  HR_Management_System
//
//  Created by Tahani on 16/04/1447 AH.
//

import Foundation

struct LeaveFlat: Decodable, Identifiable {
    let id: Int
    let type: LeaveType
    let dateFrom: Date
    let dateTo: Date?
    let leaveStatus: Status
    let users_permissions_user: UserSlim?   // populated user object

    enum CodingKeys: String, CodingKey {
        case id, type, dateFrom, dateTo, leaveStatus, users_permissions_user
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        type = try c.decode(LeaveType.self, forKey: .type)
        leaveStatus = try c.decode(Status.self, forKey: .leaveStatus)
        users_permissions_user = try? c.decode(UserSlim.self, forKey: .users_permissions_user)

        // Parse dateFrom / dateTo accepting either ISO8601 or "yyyy-MM-dd"
        let df = try c.decode(String.self, forKey: .dateFrom)
        guard let dfDate = DateParser.parse(df) else {
            throw DecodingError.dataCorruptedError(forKey: .dateFrom, in: c, debugDescription: "Bad dateFrom: \(df)")
        }
        dateFrom = dfDate

        if let dtStr = try? c.decode(String.self, forKey: .dateTo) {
            dateTo = DateParser.parse(dtStr)
        } else {
            dateTo = nil
        }
    }
}

enum DateParser {
    static func parse(_ s: String) -> Date? {
        // try ISO8601 with/without fractional seconds
        if let d = isoFractional.date(from: s) ?? isoBasic.date(from: s) { return d }
        // try yyyy-MM-dd
        if let d = ymd.date(from: s) { return d }
        return nil
    }

    private static let isoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let isoBasic: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static let ymd: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
