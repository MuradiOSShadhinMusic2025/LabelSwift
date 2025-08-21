//
//  HashTagCVCell.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 10/4/25.
//

import UIKit

class HashTagCVCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var hashTagLbl: UILabel!
    
    // MARK: - Properties
    static let identifier = "HashTagCVCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: .init(for: ShortsPlayerTVCell.self))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.contentView.layer.borderWidth = 0.8
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 0.8
        self.layer.cornerRadius = 12.5
        self.contentView.layer.cornerRadius = 12.5
        self.layer.masksToBounds = true
        self.contentView.layer.masksToBounds = true
    }
    
    func configureCell(_ hashTag: String) {
        self.hashTagLbl.text = hashTag
        self.hashTagLbl.font = UIFont.inter(.regular, size: 13)
        self.hashTagLbl.adjustsFontSizeToFitWidth = false
    }
}
