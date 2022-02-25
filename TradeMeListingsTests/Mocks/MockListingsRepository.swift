//
//  MockListingsRepository.swift
//  TradeMeListingsTests
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import Combine

class MockListingsRepository: IListingsRepository {
    public private(set) var repoMethodCalled: String = ""
    public var fail: Bool = false

    func fetchListings() -> AnyPublisher<ListingDto, Error> {
        repoMethodCalled = "fetch Listings"
        if fail {
            return Fail(error: NSError(domain: "", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
        return Just(ListingDto(totalCount: 1, list: [ListDto(listingID: 0, title: "", startPrice: 0, buyNowPrice: 0, pictureHref: "", region: "", hasBuyNow: true, reserveState: 0, isBuyNowOnly: true, priceDisplay: "", hasReserve: true, isReserveMet: false)]))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
