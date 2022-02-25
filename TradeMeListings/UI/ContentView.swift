//
//  ContentView.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/23.
//

import SwiftUI

struct ContentView: View {
    var listingsService: IListingsService!
    var listingsRepository: IListingsRepository!
    init() {
        self.listingsRepository = ListingsRepository()
        self.listingsService = ListingsService(listingsRepository: listingsRepository)
    }
    
    var body: some View {
        TabView {
            LatestListingsView(vm: .init(listingsService))
                .tabItem { Label(NSLocalizedString("Discover", comment: "Discover"), image: "search")}
            WatchlistView()
                .tabItem { Label(NSLocalizedString("Watchlist", comment: "Watchlist"), image: "watchlist")}
            MyTradeMeView()
                .tabItem { Label(NSLocalizedString("My Trade Me", comment: "My Trade Me"), image: "profile-16")}
        }.accentColor(Color.tasman)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
