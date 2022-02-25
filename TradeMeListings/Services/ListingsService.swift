//
//  ListingsService.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import Foundation
import Combine
import SwiftUI

protocol IListingsService {
    func fetchListings() -> AnyPublisher<Listings, Error>
}

struct ListingsService: IListingsService {
    private var listingsRepository: IListingsRepository
    let userWebRepositoryQueue = DispatchQueue(label: "bg_parse_queue")

    init(listingsRepository: IListingsRepository) {
        self.listingsRepository = listingsRepository
    }
    
    func fetchListings() -> AnyPublisher<Listings, Error> {
        return listingsRepository.fetchListings()
            .receive(on: DispatchQueue.main)
            .flatMap({ (response) -> AnyPublisher<Listings, Error> in
                guard let loadedListingsDto = response.list else {
                    return Fail(error: NSError(domain: "", code: -1001, userInfo: nil)).eraseToAnyPublisher()
                }
                var listings: Listings = []
                for listingDto in loadedListingsDto {
                    listings.append(
                        Listing(listingID: String(listingDto.listingID),
                                imageUrl: listingDto.pictureHref ?? "",
                                location: listingDto.region ?? "",
                                description: listingDto.title ?? "",
                                isBuyNowOnly: listingDto.isBuyNowOnly ?? false,
                                hasBuyNow: listingDto.hasBuyNow ?? false,
                                buyNowPrice: String(format: "%.2f", listingDto.buyNowPrice ?? 0.00),
                                currentPrice: listingDto.priceDisplay ?? "",
                                startPrice: String(format: "%.2f", listingDto.startPrice ?? 0.00),
                                isReserveMet: listingDto.isReserveMet ?? false)
                    )
                }
                return AnyPublisher<Listings, Error>.init(Result<Listings, Error>.Publisher(listings))
            }).eraseToAnyPublisher()
    }
}
