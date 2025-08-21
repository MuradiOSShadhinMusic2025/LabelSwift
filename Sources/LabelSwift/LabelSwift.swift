// The Swift Programming Language
// https://docs.swift.org/swift-book


import UIKit

public class LabelSwift {
    
    public init() {}
    
    @MainActor public func makeLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        return label
    }
}
