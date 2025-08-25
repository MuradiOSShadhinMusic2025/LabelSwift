//
//  SeeAllCommonCell.swift
//  Shadhin_shorts
//
//  Created by Maruf on 13/4/25.
//

import UIKit

class SeeAllCommonCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var songTitileLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientImgView: UIImageView!
    
    // MARK: - Properties
    static var identifier : String{
        return String(describing: self)
    }
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    
    static var sizeSeeAll: CGSize {
        let aspectRatio = 136.0 / 262.0
        let itemsPerRow: CGFloat = 2
        let horizontalSpacing: CGFloat = 0 // Space between columns
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
    
    // MARK: - Actions
}


// MARK: - Private Methods
extension SeeAllCommonCell {
    
    private func setupUI() {
        self.gradientImgView.layer.cornerRadius = 12
        self.gradientImgView.clipsToBounds = true
        self.gradientImgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func dataBind(data: ReelsContent) {
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = 12
            self.imageView.clipsToBounds = true
            self.imageView.contentMode = .scaleAspectFill
            if let imageURL = URL(string: data.imageURL?.img300 ?? "") {
                self.imageView.kf.setImage(with: imageURL)
            }
            self.songTitileLbl.text = data.title
        }
    }
}
