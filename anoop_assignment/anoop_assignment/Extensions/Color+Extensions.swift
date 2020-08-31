//
//  Color+Extensions.swift
//  anoop_assignment
//
//  Created by Apple on 27/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let aValue, rValue, gValue, bValue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aValue, rValue, gValue, bValue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aValue, rValue, gValue, bValue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (aValue, rValue, gValue, bValue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (aValue, rValue, gValue, bValue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(rValue) / 255, green: CGFloat(gValue) / 255, blue: CGFloat(bValue) / 255, alpha: CGFloat(aValue) / 255)
    }
}
