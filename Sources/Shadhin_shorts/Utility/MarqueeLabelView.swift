//
//  MarqueeLabelView.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 16/4/25.
//


import UIKit

class MarqueeLabelView: UIView {
    
    private let label1 = UILabel()
    private let label2 = UILabel()
    private var isAnimating = false

    var text: String? {
        didSet {
            label1.text = text
            label2.text = text
            setupLabels()
        }
    }

    var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            label1.font = font
            label2.font = font
        }
    }

    var textColor: UIColor = .black {
        didSet {
            label1.textColor = textColor
            label2.textColor = textColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        clipsToBounds = true
        addSubview(label1)
        addSubview(label2)
    }

    private func setupLabels() {
        label1.sizeToFit()
        label2.sizeToFit()

        let labelWidth = label1.bounds.width
        let spacing: CGFloat = 40

        label1.frame = CGRect(x: 0, y: 0, width: labelWidth, height: bounds.height)
        label2.frame = CGRect(x: labelWidth + spacing, y: 0, width: labelWidth, height: bounds.height)

        startAnimation()
    }

    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true

        let totalWidth = label1.bounds.width + 40

        UIView.animateKeyframes(withDuration: Double(totalWidth / 30), delay: 0, options: [.repeat, .calculationModeLinear], animations: {
            self.label1.frame.origin.x = -totalWidth
            self.label2.frame.origin.x = 0
        }, completion: nil)
    }

    func stopAnimation() {
        isAnimating = false
        label1.layer.removeAllAnimations()
        label2.layer.removeAllAnimations()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabels()
    }
}
