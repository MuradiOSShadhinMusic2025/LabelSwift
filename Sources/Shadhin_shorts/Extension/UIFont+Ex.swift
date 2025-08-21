//
//  InterFont.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 25/3/25.
//

import UIKit

extension UIFont {
    enum Inter: String {
        case black = "Inter-Black"
        case bold = "Inter-Bold"
        case extraLight = "Inter-ExtraLight"
        case italic = "Inter-Italic"
        case medium = "Inter-Medium"
        case regular = "Inter-Regular"
        case semiBold = "Inter-SemiBold"
        case displayMedium = "InterDisplay-Medium"
    }
    
    enum CircularStd: String {
        case black = "CircularStd-Black"
        case bold = "CircularStd-Bold"
        case book = "CircularStd-Book"
        case medium = "CircularStd-Medium"
    }

    static func inter(_ style: Inter, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func circularStd(_ style: CircularStd, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
