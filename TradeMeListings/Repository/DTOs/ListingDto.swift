//
//  ListingDto.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import Foundation

struct ListingDto: Codable {
    let totalCount: Int?
    let list: [List]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case list = "List"
    }
}

struct List: Codable {
    let listingID: Int
    let title: String?
    let startPrice: Double?
    let buyNowPrice: Double?
    let pictureHref: String?
    let region: String?
    let hasBuyNow: Bool?
    let reserveState: Int?
    let isBuyNowOnly: Bool?
    let priceDisplay: String?
    let hasReserve: Bool?

    enum CodingKeys: String, CodingKey {
        case listingID = "ListingId"
        case title = "Title"
        case startPrice = "StartPrice"
        case buyNowPrice = "BuyNowPrice"
        case pictureHref = "PictureHref"
        case region = "Region"
        case hasBuyNow = "HasBuyNow"
        case reserveState = "ReserveState"
        case isBuyNowOnly = "IsBuyNowOnly"
        case priceDisplay = "PriceDisplay"
        case hasReserve = "HasReserve"
    }
}
