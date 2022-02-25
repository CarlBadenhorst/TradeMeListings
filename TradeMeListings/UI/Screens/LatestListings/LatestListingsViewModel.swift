//
//  LatestListingsViewModel.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import Combine

class LatestListingsViewModel: ObservableObject {
    private var listingService: IListingsService
    var subscriptions = Set<AnyCancellable>()
    @Published var listings: Listings = []
    @Published var resultText: String = ""

    init(_ listingService: IListingsService) {
        self.listingService = listingService
        loadAllListings()
    }
    
    func loadAllListings() {
        self.resultText = NSLocalizedString("Loading..", comment: "Loading..")
        self.listingService.fetchListings().sink(receiveCompletion: { result in
            switch result {
            case .failure( _): do { self.resultText = NSLocalizedString("Error Loading Listings", comment: "Error Loading Listings") }
            case .finished: do {}
            }
        }, receiveValue: { response in
            self.listings = response
            self.resultText = ""
        }).store(in: &subscriptions)
    }
}
