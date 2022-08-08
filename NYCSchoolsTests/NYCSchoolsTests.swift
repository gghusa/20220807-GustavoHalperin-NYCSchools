//
//  NYCSchoolsTests.swift
//  NYCSchoolsTests
//
//  Created by Gustavo Halperin on 8/7/22.
//

import XCTest
@testable import NYCSchools
import Combine


/**
 Test fetch School's list and Schoo results.
 */
class NYCSchoolsTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSchoolSrvrDirectory() throws {
        var receivedValue: [SchoolInfo]?
        var error: Error?
        let expectation = self.expectation(description: "SchoolSrvrDirectory")
        
        SchoolSrvr.shared.directoryPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                // Fullfilling our expectation to unblock
                // our test execution:
                expectation.fulfill()
            }, receiveValue: { value in
                receivedValue = value
            })
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)
        
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNil(error)
        let schoolInfoList = try XCTUnwrap(receivedValue)
        XCTAssertTrue(schoolInfoList.count > 0)
    }
    
    func testSchoolSrvrResult() throws {
        let dbn = "01M292"
        var receivedValue: SchoolResults?
        var error: Error?
        let expectation = self.expectation(description: "SchoolSrvrResult")
        
        SchoolSrvr.shared.schoolResultsPublisher(dbn: dbn)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                // Fullfilling our expectation to unblock
                // our test execution:
                expectation.fulfill()
            }, receiveValue: { value in
                receivedValue = value
            })
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)
        
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNil(error)
        let schoolResult = try XCTUnwrap(receivedValue)
        XCTAssertEqual(schoolResult.dbn, dbn)
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
