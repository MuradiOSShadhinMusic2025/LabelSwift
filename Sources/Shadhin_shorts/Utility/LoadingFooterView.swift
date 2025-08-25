//
//  LoadingFooterView.swift
//  Shadhin_shorts_Test
//
//  Created by MD Murad Hossain on 29/4/25.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {
    static let identifier = "LoadingFooterView"

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        spinner.center = center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    func startAnimating() {
        spinner.startAnimating()
    }

    func stopAnimating() {
        spinner.stopAnimating()
    }
}

