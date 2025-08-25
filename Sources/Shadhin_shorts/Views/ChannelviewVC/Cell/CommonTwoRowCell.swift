//
//  CommonTwoRowCell.swift
//  Shadhin_shorts
//
//  Created by MD Murad Hossain on 29/4/25.
//

import UIKit

class CommonTwoRowCell: UICollectionViewCell {
    
    // MARK: ---- Outlets ----
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    
    // MARK: ---- Properties ----
    static var identifier : String{
        return String(describing: self)
    }
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    static var sizeTwoRowCelll: CGSize {
        let aspectRatio = 136.0 / 200.0
        let itemsPerRow: CGFloat = 2
        let horizontalSpacing: CGFloat = 0
        let totalHorizontalSpacing = horizontalSpacing * (itemsPerRow - 1)
        let availableWidth = DEVICE_WIDTH - 48 - totalHorizontalSpacing
        let width = availableWidth / itemsPerRow
        let height = width / aspectRatio
        return CGSize(width: width, height: height)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.setupUI()
        }

    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        self.imageView.layer.cornerRadius = 10
        self.titleLabel.font = UIFont.inter(.regular, size: 14)
        self.hashTagLabel.font = UIFont.inter(.semiBold, size: 12)
        self.gradientImgView.layer.cornerRadius = 12
        self.gradientImgView.clipsToBounds = true
        self.gradientImgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func dataBindCell(data: ReelsContent?, isHashTag: Bool, hashTag: String) {
        self.imageView.kf.setImage(with: URL(string: data?.imageURL?.image300 ?? ""))
        self.titleLabel.text = data?.title
        self.hashTagLabel.text = "#\(hashTag)"
        self.hashTagLabel.isHidden = !isHashTag
    }
}
