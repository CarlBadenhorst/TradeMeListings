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
    static var textDark: Color {
        guard let color_text_dark = UIColor(named: "color_text_dark") else {
            return Color.gray
        }
        return Color(color_text_dark)
    }
    static var textLight: Color {
        guard let color_text_light = UIColor(named: "color_text_light") else {
            return Color.gray
        }
        return Color(color_text_light)
    }
}
