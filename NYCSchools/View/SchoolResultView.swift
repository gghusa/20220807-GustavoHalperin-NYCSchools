//
//  SchoolResultView.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/8/22.
//

import SwiftUI

/**
 Straight forward View.
 */
struct SchoolResultView: View {
    var schoolResult: SchoolResults
    var body: some View {
        VStack (alignment: .leading) {
            Text(schoolResult.school_name)
                .font(.largeTitle)
                .padding()
            VStack (alignment: .leading) {
                HStack {
                    Text("Num of SAT test tackers")
                    Spacer()
                    Text(schoolResult.num_of_sat_test_takers)
                }
                .padding()
                HStack {
                    Text("SAT Critical Reading Avg Score")
                    Spacer()
                    Text(schoolResult.sat_critical_reading_avg_score)
                }
                .padding()
                HStack {
                    Text("SAT Math Avg Score")
                    Spacer()
                    Text(schoolResult.sat_math_avg_score)
                }
                .padding()
                HStack {
                    Text("SAT Writing Avg Score")
                    Spacer()
                    Text(schoolResult.sat_writing_avg_score)
                }
                .padding()
            }.padding()
            Spacer()
        }
    }
}

struct SchoolResultView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolResultView(schoolResult: SchoolResults(
            dbn: "01M292",
            school_name: "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES",
            num_of_sat_test_takers: "29",
            sat_critical_reading_avg_score: "355",
            sat_math_avg_score: "404",
            sat_writing_avg_score: "363"))
    }
}
