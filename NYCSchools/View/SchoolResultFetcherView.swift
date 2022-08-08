//
//  SchoolResultFetcherView.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/8/22.
//

import SwiftUI

/**
 Shows a loading view if the model is fetching the School's results.
 In case of error the user is infromaed about that and with the user confirmation the page is dissmised.
 Otherwise the Shcool result is presented.
 */
struct SchoolResultFetcherView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model: Model
    @State private var showingLoadingView = true
    @State private var showingAlert = false
    let dbn: String
    var body: some View {
        LoadingView(isShowing: showingLoadingView) {
            SchoolResultView(schoolResult: schoolResult)
        }
        .onAppear { onAppear() }
        .onDisappear { onDisappear() }
        .onChange(of: model.errorMssg, perform: onChangeErrorMssg)
        .onChange(of: model.results, perform: onChange )
        .alert(isPresented:$showingAlert) { alert }
    }
}

/**
 Computed Attributes
 */
extension SchoolResultFetcherView {
    var schoolResult: SchoolResults {
        guard let value = model.results[dbn] else {
            return SchoolResults.loading
        }
        return value
    }
    var alert: Alert {
        Alert(title: Text("Error loadin School Resulst"),
              message: Text("\(model.errorMssg ?? "")"),
              dismissButton: .default(Text("OK"), action: {
            presentationMode.wrappedValue.dismiss()
        }))
    }
}
/**
 Helper functions
 */
extension SchoolResultFetcherView {
    func onAppear() {
        guard model.errorMssg == nil else {
            self.onChangeErrorMssg(newValue: model.errorMssg)
            return
        }
        if model.results[dbn] == nil {
            model.fetchResults(dbn: dbn)
        } else {
            showingLoadingView = false
        }
    }
    func onDisappear() {
        model.fetcher?.cancel()
        model.errorMssg = nil
    }
    func onChangeErrorMssg(newValue:String?) {
        guard let _ = newValue else {
            return
        }
        showingLoadingView = false
        showingAlert = true
    }
    func onChange(newValue: [String:SchoolResults]) {
        if newValue[dbn] != nil {
            showingLoadingView = false
        }
    }
}

struct SchoolResultFetcherView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolResultFetcherView(dbn: "01M292")
            .environmentObject(Model())
    }
}
