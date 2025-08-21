//
//  LinkLabel.swift
//  Shadhin_shorts_Test
//
//  Created by Muhammad Murad Hossain on 8/5/25.
//


import UIKit

class LinkLabel: UILabel {
    
    private var linkText: String?
    private var linkRange: NSRange?
    private var linkAction: (() -> Void)?
    
    func setText(_ fullText: String, linkText: String, font: UIFont, onTap: @escaping () -> Void) {
        self.linkText = linkText
        self.linkAction = onTap
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttribute(.font, value: font, range: fullRange)
        
        if let range = fullText.range(of: linkText) {
            let nsRange = NSRange(range, in: fullText)
            self.linkRange = nsRange
            attributedString.addAttributes([
                .font: font,
                .foregroundColor: UIColor.systemBlue
            ], range: nsRange)
        }
        
        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let range = linkRange else { return }
        if gesture.didTapAttributedTextInLabel(label: self, inRange: range) {
            linkAction?()
        }
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let location = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let offset = CGPoint(
            x: (label.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
            y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY
        )
        let locationInTextContainer = CGPoint(x: location.x - offset.x, y: location.y - offset.y)

        let characterIndex = layoutManager.characterIndex(for: locationInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(characterIndex, targetRange)
    }
}
