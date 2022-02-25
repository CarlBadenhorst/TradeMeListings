//
//  MockListingsService.swift
//  TradeMeListingsTests
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import Combine

class MockListingService: IListingsService {
    public private(set) var serviceMethodCalled: String = ""
    public var fail: Bool = false

    func fetchListings() -> AnyPublisher<Listings, Error> {
        self.serviceMethodCalled = "fetchListings"
        if fail {
            return Fail(error: NSError(domain: "", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
        return Just([Listing(listingID: "", imageUrl: "", location: "", description: "", isBuyNowOnly: true, hasBuyNow: true, buyNowPrice: "", currentPrice: "", startPrice: "")])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
