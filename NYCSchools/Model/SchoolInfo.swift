//
//  SchoolInfo.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/7/22.
//

import Foundation

struct SchoolInfo: Codable {
    let dbn: String
    let school_name: String
    let neighborhood: String
    let website: String
}
extension SchoolInfo: Identifiable, Hashable {
    var id: String { dbn }
}

extension SchoolInfo {
    enum API {
        private static let fields: [String] =
            ["dbn", "school_name", "neighborhood", "website"]
        static let headerFieldName = "X-SODA2-Fields"
        static var headerFieldValue: String? {
            get throws { try fields.serialized }
        }
    }
}
