//
//  NYCSchoolsApp.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/7/22.
//

import SwiftUI


/**
 The app has one model that is passed as environmentObject.
 */
@main
struct NYCSchoolsApp: App {
    let model = Model()
    var body: some Scene {
        WindowGroup {
            DirectoryView()
                .environmentObject(model)
        }
    }
}
