//
//  LatestListingsView.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import Foundation
import SwiftUI

struct LatestListingsView: View {
    @ObservedObject var vm: LatestListingsViewModel
    
    var body: some View {
        if self.vm.listings.count > 0 {
            List {
                ForEach(self.vm.listings, id: \.listingID) { listing in
                    ListingRow(listing: listing).frame(height: 96)
                }
            }
        } else {
            Text(self.vm.resultText)
        }
    }
}
