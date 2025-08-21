//
//  UILabel+Ex.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 16/4/25.
//

import UIKit

extension UILabel {
    func startMarquee(duration: Double = 8.0, delay: Double = 1.0) {
        self.layer.removeAllAnimations()
        
        guard let text = self.text, !text.isEmpty else { return }

        let labelWidth = self.intrinsicContentSize.width
        let containerWidth = self.bounds.width

        if labelWidth <= containerWidth { return }
        let offset = labelWidth - containerWidth
        self.transform = CGAffineTransform(translationX: 0, y: 0)

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveLinear, .repeat],
            animations: {
                self.transform = CGAffineTransform(translationX: -offset, y: 0)
            },
            completion: nil
        )
    }

    func stopMarquee() {
        self.layer.removeAllAnimations()
        self.transform = .identity
    }
}


extension UILabel {
    /// Applies bold font to a specific substring within the full text
    func setBoldText(fullText: String, boldPart: String) {
        let regularFont = UIFont.inter(.regular, size: 16)
        let boldFont = UIFont.inter(.bold, size: 16)

        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: regularFont
        ])

        if let range = fullText.range(of: boldPart) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
        }

        self.attributedText = attributedString
    }
}
