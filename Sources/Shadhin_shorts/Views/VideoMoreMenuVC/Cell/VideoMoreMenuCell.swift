//
//  VideoMoreMenuCellCollectionViewCell.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 7/5/25.
//

import UIKit


class VideoMoreMenuCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    static var size: CGSize {
        let designHeight: CGFloat = 54.0
        let aspectRatio = designHeight / (DEVICE_WIDTH - 40)
        let cellHeight = DEVICE_WIDTH * aspectRatio
        return CGSize(width: DEVICE_WIDTH, height: DEVICE_HIEGHT > 736 ? cellHeight : 75.0)
    }
    
    static var sizeSecond: CGSize {
        let designHeight: CGFloat = 38.0
        let aspectRatio = designHeight / (DEVICE_WIDTH - 40)
        let cellHeight = DEVICE_WIDTH * aspectRatio
        return CGSize(width: DEVICE_WIDTH, height: DEVICE_HIEGHT > 736 ? cellHeight : 52.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [self] in
            self.setupCellUI()
        }
    }
        
    private func setupCellUI() {
        self.titleLabel.font = UIFont.inter(.medium, size: 16)
        self.subTitleLabel.font = UIFont.inter(.regular, size: 14)
        self.separatorView.backgroundColor = .topBarModeTypeColor.withAlphaComponent(0.3)
    }

    func dataBind(data: VideoMoreMenuItems) {
        self.imageView.image = data.image
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.subTitle
        self.titleLabel.textColor = data.isRed ?? false ? .red : .textViewBgColor
        self.imageView.tintColor = data.isRed ?? false ? .red : .textViewBgColor
        self.imageView.isHidden = data.image == nil
        self.subTitleLabel.isHidden = data.subTitle == nil
    }
}
