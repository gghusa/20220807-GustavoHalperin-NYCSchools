//
//  DirectoryView.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/7/22.
//

import SwiftUI

/**
 Show a loading view if the model is fetching the list of schools,
 otherwise show the list.
 */
struct DirectoryView: View {
    @EnvironmentObject var model: Model
    @State private var showingLoadingView = true
    var body: some View {
        NavigationView {
            VStack {
                if showingLoadingView {
                    LoadingView(isShowing: showingLoadingView) {
                        List(model.schoolInfoList) { schoolInfo in
                            NavigationLink(destination: SchoolResultFetcherView(dbn: schoolInfo.dbn)) {
                                SchoolInfoView(schoolInfo: schoolInfo)
                            }
                        }
                    }
                } else {
                    List(model.schoolInfoList) { schoolInfo in
                        NavigationLink(destination: SchoolResultFetcherView(dbn: schoolInfo.dbn)) {
                            SchoolInfoView(schoolInfo: schoolInfo)
                        }
                    }
                }
            }
            .navigationTitle("NYC Schools")
        }
        .onAppear { onAppear() }
        .onChange(of: model.schoolInfoList, perform: onChange )
    }
}

/**
 Helper functions
 */
extension DirectoryView {
    func onAppear() {
        if model.schoolInfoList.count > 0 {
            showingLoadingView = false
        }
    }
    func onChange(newValue: [SchoolInfo]) {
        if model.schoolInfoList.count > 0 {
            showingLoadingView = false
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
            .environmentObject(Model())
    }
}
