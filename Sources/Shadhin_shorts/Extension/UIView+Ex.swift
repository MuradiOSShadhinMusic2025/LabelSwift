//
//  UIView+Ex.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 16/4/25.
//

import UIKit

extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension UIView {
    func pushTransition(_ duration: CFTimeInterval, direction: CATransitionSubtype = .fromTop) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .push
        animation.subtype = direction
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
