//
//  Listing.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import Foundation

typealias Listings = [Listing]
struct Listing {
    let listingID: String
    let imageUrl: String
    let location: String
    let description: String
    let isBuyNowOnly: Bool
    let hasBuyNow: Bool
    let buyNowPrice: String
    let currentPrice: String
    let startPrice: String
    let isReserveMet: Bool
}
