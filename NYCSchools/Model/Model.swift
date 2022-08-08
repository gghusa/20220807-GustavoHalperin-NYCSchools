//
//  Model.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/8/22.
//

import Foundation
import Combine

class Model: ObservableObject {
    @Published var schoolInfoList = [SchoolInfo]()
    @Published var results = [String:SchoolResults]()
    @Published var errorMssg: String?
    var fetcher: AnyCancellable?
    init() {
        fetcher = SchoolSrvr.shared.directoryPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    self?.errorMssg = encounteredError.localizedDescription
                }
                self?.fetcher = nil
            }, receiveValue: { [weak self] value in
                self?.schoolInfoList = value
                self?.fetcher = nil
            })
    }
    func fetchResults(dbn:String) {
        self.errorMssg = nil
        fetcher = SchoolSrvr.shared.schoolResultsPublisher(dbn: dbn)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.errorMssg = "No info about school with dbn \(dbn)"
                    break
                case .failure(let encounteredError):
                    self?.errorMssg = encounteredError.localizedDescription
                }
                self?.fetcher = nil
            }, receiveValue: { [weak self] value in
                self?.results[dbn] = value
                self?.fetcher = nil
            })
    }
}
