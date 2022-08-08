//
//  SchoolSrv.swift
//  NYCSchools
//
//  Created by Gustavo Halperin on 8/7/22.
//

import Foundation
import Combine

fileprivate
enum AppToken {
    static let headerFieldValue = "7najTi8pOn3rM89jNiL9NkIl0"
    static let headerFieldName = "X-App-Token"
}

class SchoolSrvr {
    enum Errors: Error {
        case fataError(mssg:String)
    }
    static var shared = SchoolSrvr()
    private
    enum Server {
        static let baseURL = "https://data.cityofnewyork.us/resource/"
        static let directory = "s3k6-pzi2.json"
        static let results = "f9bf-2cp4.json"
    }
    private let urlSession: URLSession
    private init() {
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
}
/**
 Directory request and publisher
 */
extension SchoolSrvr {
    func directoryRequest() throws -> URLRequest {
        var urlStr = Server.baseURL
        urlStr += Server.directory
        guard let url = URL(string: urlStr) else {
            throw Errors.fataError(mssg: "Bad URL \(urlStr)")
        }
        var request = URLRequest(url: url)
        request.addValue(AppToken.headerFieldValue,
                         forHTTPHeaderField: AppToken.headerFieldName)
        
        guard let schoolInfoHeaderFieldValue = try SchoolInfo.API.headerFieldValue else {
            throw Errors.fataError(mssg: "SchoolInfo.API error")
        }
        request.addValue(schoolInfoHeaderFieldValue,
                         forHTTPHeaderField: SchoolInfo.API.headerFieldName)
        return request
    }
    
    func directoryPublisher() -> AnyPublisher<[SchoolInfo], Error> {
        do {
            let request = try self.directoryRequest()
            return self.urlSession.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: [SchoolInfo].self, decoder: JSONDecoder())
                .catch { _ in
                    Empty<[SchoolInfo], Error>()
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    func fetchDirectory() async throws -> AnyPublisher<[SchoolInfo], Error> {
        return self.directoryPublisher()
    }
}

/**
 Per School result request and publisher
 */
extension SchoolSrvr {
    func schoolResultsRequest(dbn:String) throws -> URLRequest {
        var urlStr = Server.baseURL
        urlStr += Server.results
        urlStr += "?dbn=\(dbn)"
        
        guard let url = URL(string: urlStr) else {
            throw Errors.fataError(mssg: "Bad URL \(urlStr)")
        }
        var request = URLRequest(url: url)
        request.addValue(AppToken.headerFieldValue,
                         forHTTPHeaderField: AppToken.headerFieldName)
        return request
    }
    
    func schoolResultsPublisher(dbn:String) -> AnyPublisher<SchoolResults, Error> {
        do {
            let request = try self.schoolResultsRequest(dbn: dbn)
            return self.urlSession.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: [SchoolResults].self, decoder: JSONDecoder())
                .flatMap({ schoolResults -> AnyPublisher<SchoolResults, Error> in
                    guard schoolResults.count == 1 else {
                        return Fail(error: Errors.fataError(mssg: "Empty"))
                            .eraseToAnyPublisher()
                    }
                    let schoolResult = schoolResults[0]
                    return Just(schoolResult)
                        .catch { _ in
                            Empty<SchoolResults, Error>()
                        }
                        .eraseToAnyPublisher()
                })
                .catch { _ in
                    Empty<SchoolResults, Error>()
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
    func fetchResults(dbn:String) async throws -> AnyPublisher<SchoolResults, Error> {
        return self.schoolResultsPublisher(dbn: dbn)
    }
}

