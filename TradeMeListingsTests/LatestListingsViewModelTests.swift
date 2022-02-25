//
//  LatestListingsViewModelTests.swift
//  TradeMeListingsTests
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import XCTest
import Combine
@testable import TradeMeListings

class LatestListingsViewModelTests: XCTestCase {

    //var sut: LatestListingsViewModel!
    var mockListingsService: MockListingService!
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        mockListingsService = MockListingService()
    }

    override func tearDownWithError() throws {

    }

    func testInitCallsFetchListingsService() throws {
        let sut = LatestListingsViewModel(mockListingsService)
        XCTAssertEqual("fetchListings", self.mockListingsService.serviceMethodCalled)
    }
    
    func testLoadAllDataSuccessLoadsListings() {
        let sut = LatestListingsViewModel(mockListingsService)
        let expectation = self.expectation(description: "Listings were received")
        sut.$listings.sink { value in
            if value.count > 0 {
                XCTAssertTrue(value.count == 1)
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(sut.resultText.count == 0)
    }
    
    func testLoadAllDataFailureDisplaysErrorMessage() {
        let expectation = self.expectation(description: "Error from retrieving listings received")
        self.mockListingsService.fail = true
        let sut = LatestListingsViewModel(mockListingsService)
        sut.$resultText.sink { result in
            if result.count > 0 {
                XCTAssertTrue(result.caseInsensitiveCompare("Error Loading Listings") == .orderedSame)
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 5)
    }
}
