//
//  SchoolInfoView.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/8/22.
//

import SwiftUI

/**
 School info with option to open the link the the iOS browser.
 */
struct SchoolInfoView: View {
    let schoolInfo: SchoolInfo
    var body: some View {
        VStack(alignment: .leading) {
            Text(schoolInfo.school_name)
                .font(.title)
            Text(schoolInfo.neighborhood)
                .foregroundColor(.gray)
            Text(schoolInfo.website)
                .foregroundColor(.blue)
                .onTapGesture() { goToWesite() }
        }
    }
    func goToWesite() {
        guard let url = URL(string: schoolInfo.website) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}

struct SchoolInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolInfoView(schoolInfo: SchoolInfo(
            dbn: "02M260",
            school_name: "Clinton School Writers & Artists, M.S. 260",
            neighborhood: "Chelsea-Union Sq",
            website: "www.theclintonschool.net"))
        .previewLayout(.sizeThatFits)
    }
}
