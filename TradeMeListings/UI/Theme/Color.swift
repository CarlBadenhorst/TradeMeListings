//
//  Color.swift
//  TradeMeListings
//
//  Created by Carl Badenhorst on 2022/02/24.
//

import SwiftUI

extension Color {
    static var tasman: Color {
        guard let color_tasman = UIColor(named: "color_tasman_500") else {
            return Color.blue
        }
        return Color(color_tasman)
    }
}
