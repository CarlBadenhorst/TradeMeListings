//
//  ListingsRepository.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import Foundation
import Combine

protocol IListingsRepository {
    func fetchListings() -> AnyPublisher<ListingDto, Error>
}
