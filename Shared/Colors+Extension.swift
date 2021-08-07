//
//  Colors+Extension.swift
//  Pusher
//
//  Created by Rajesh Budhiraja on 02/08/21.
//

import SwiftUI

extension Color {

    init(hexColor: String) {
        // Trim all characters excepts Alphanumerics
        let hex = hexColor.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let hexNumber = Int(hex, radix: 16) ?? 0
        let redColor: Double = Double((hexNumber >> 16) & 0xFF) / Double(255)
        let greenColor: Double = Double((hexNumber >> 8) & 0xFF) / Double(255)
        let blueColor: Double = Double((hexNumber >> 0) & 0xFF) / Double(255)
        self.init(.sRGB, red: redColor, green: greenColor, blue: blueColor, opacity: 1)
    }
}

class AppColors {
    static let PRIMARY_COLOR = Color(hexColor: "505160")
    static let TEXT_BACKGROUND_COLOR = Color.white
    static let TEXT_COLOR = Color.black
}
