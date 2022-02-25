//
//  ListingRow.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/25.
//

import Foundation
import SwiftUI
import Combine

struct ListingRow: View {
    var listing: Listing
    
    var body: some View {
        HStack(spacing: 0) {
            RemoteImage(url: listing.imageUrl)
                .aspectRatio(contentMode: .fill)
                .frame(width: 82, height: 82, alignment: .center)
                .cornerRadius(8)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(listing.location)
                    .font(.system(size: 11))
                    .foregroundColor(Color.textLight)
                Text(listing.description)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color.textDark)
                    .lineLimit(2)
                Spacer()
                PriceView
            }.padding([.top, .bottom], 8)
        }
    }
}

extension ListingRow {
    var PriceView: AnyView {
        return AnyView(
            HStack {
                VStack(alignment: .leading) {
                    if !listing.isBuyNowOnly {
                        Text(listing.currentPrice)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(Color.textDark)
                        Text(listing.isReserveMet ? "Reserve met": "No reserve")
                            .font(.system(size: 11))
                            .foregroundColor(Color.textLight)
                    }
                }
                Spacer()
                HStack {
                    if listing.hasBuyNow {
                        Spacer()
                        VStack(alignment: .trailing) {
                                Text(listing.buyNowPrice)
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.textDark)
                                Text("Buy Now")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color.textLight)
                        }
                    }
                }
            }
        )
    }
}
