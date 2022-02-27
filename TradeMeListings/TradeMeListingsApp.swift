//
//  TradeMeListingsApp.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/23.
//

import SwiftUI

@main
struct TradeMeListingsApp: App {
    init() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
