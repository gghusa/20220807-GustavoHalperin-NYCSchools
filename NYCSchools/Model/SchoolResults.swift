//
//  SchoolResults.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/8/22.
//

import Foundation

struct SchoolResults: Codable {
    let dbn: String
    let school_name: String
    let num_of_sat_test_takers: String
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String
}

extension SchoolResults: Equatable { }

extension SchoolResults {
    static let loading = SchoolResults(
        dbn: "***",
        school_name: "***",
        num_of_sat_test_takers: "***",
        sat_critical_reading_avg_score: "***",
        sat_math_avg_score: "***",
        sat_writing_avg_score: "***")
}
