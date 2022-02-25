//
//  LoadListingsServiceTests.swift
//  TradeMeListingsTests
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import XCTest
import Combine
@testable import TradeMeListings

class LoadListingsServiceTests: XCTestCase {
    var mockListingsRepo: MockListingsRepository!
    var subscriptions = Set<AnyCancellable>()
    var sut: IListingsService!

    override func setUpWithError() throws {
        mockListingsRepo = MockListingsRepository()
        sut = ListingsService(listingsRepository: mockListingsRepo)
    }

    override func tearDownWithError() throws {

    }

    func testFetchListingsCallsRepo() throws {
        self.sut.fetchListings().sink(receiveCompletion: {_ in }, receiveValue: {_ in })
        XCTAssertEqual("fetch Listings", self.mockListingsRepo.repoMethodCalled)
    }
    
    func testLoadAllDataSuccessLoadsListings() {
        var error: Error?
        let expectation = self.expectation(description: "ListingsDTO was received")
        var expectedReturn: Listings?
        
        self.sut.fetchListings().sink(receiveCompletion: {completion in
            switch completion {
            case .finished:
                break
            case .failure(let errorReceived):
                error = errorReceived
            }
            expectation.fulfill()
        }, receiveValue: {value in
            expectedReturn = value
        }).store(in: &subscriptions)
        
        waitForExpectations(timeout: 5)
        XCTAssertNil(error)
        XCTAssertEqual(expectedReturn?.count, 1)
    }

    func testLoadAllDataFailureDisplaysErrorMessage() {
        var error: Error?
        let expectation = self.expectation(description: "Error was received")
        var expectedReturn: Listings?
        
        self.mockListingsRepo.fail = true
        self.sut.fetchListings().sink(receiveCompletion: {completion in
            switch completion {
            case .finished:
                break
            case .failure(let errorReceived):
                error = errorReceived
            }
            expectation.fulfill()
        }, receiveValue: {value in
            expectedReturn = value
        }).store(in: &subscriptions)
        
        waitForExpectations(timeout: 5)
        XCTAssertNotNil(error)
        XCTAssertNil(expectedReturn)
    }
}
