//
//  Foundation+Ext.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/7/22.
//

import Foundation

extension Array {
    var serialized: String? {
        get throws {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        }
    }
}
