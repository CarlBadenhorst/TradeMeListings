//
//  ContentView.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    var listingsService: IListingsService!
    var listingsRepository: IListingsRepository!
    var latestListingsViewModel: LatestListingsViewModel!
    init() {
        self.listingsRepository = ListingsRepository()
        self.listingsService = ListingsService(listingsRepository: listingsRepository)
        self.latestListingsViewModel = LatestListingsViewModel(listingsService)
    }
    @State var navBarTitle: String = "Browse"
    @State private var selection: Int = 1
    @State private var showAlert: Bool = false
    @State var alertText: String = ""

    var body: some View {
        NavigationView {
            TabView(selection: $selection){
                LatestListingsView(vm: self.latestListingsViewModel)
                    .tabItem { Label("Discover", image: "search")}.tag(1)
                WatchlistView()
                    .tabItem { Label("Watchlist", image: "watchlist")}.tag(2)
                MyTradeMeView()
                    .tabItem { Label("My Trade Me", image: "profile-16")}.tag(3)
            }.onReceive(Just(selection)) { index in
                switch selection {
                case 1: navBarTitle = "Browse"
                case 2: navBarTitle = "My Watchlist"
                case 3: navBarTitle = "My Trade Me"
                default:
                    navBarTitle = "Browse"
                }
            }.accentColor(Color.tasman)
            .navigationBarTitle(navBarTitle, displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        alertText = "Search selected"
                        showAlert.toggle()
                    }, label: {
                        Image("search")
                    })
                    Button(action: {
                        alertText = "Cart selected"
                        showAlert.toggle()

                    }, label: {
                        Image("cart")
                    })
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertText)
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
