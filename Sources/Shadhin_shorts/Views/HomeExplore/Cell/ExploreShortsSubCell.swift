//
//  ExploreShortsSubCell.swift
//  Shadhin_shorts
//
//  Created by Maruf on 25/3/25.
//

import UIKit

class ExploreShortsSubCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var gradientImgView: UIImageView!
    @IBOutlet weak var songTitleName: UILabel!
    
    // MARK: - Properties
    static var size: CGSize {
        let designWidth: CGFloat = 260.0
        let designHeight: CGFloat = 383.0
        let aspectRatio = designHeight / designWidth // H / W
        let availableWidth = DEVICE_WIDTH - 16
        let cellWidth = availableWidth / 1.5
        let cellHeight = cellWidth * aspectRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }

    static var identifier : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCellUI()
    }
    
    // MARK: - Actions
    
}

// MARK: - Private Methods
extension ExploreShortsSubCell {
    
    private func setupCellUI() {
        self.gradientImgView.layer.cornerRadius = 12
        self.gradientImgView.clipsToBounds = true
        self.gradientImgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func dataBind(data: ReelsContent) {
        DispatchQueue.main.async {
            self.imgView.layer.cornerRadius = 12
            self.imgView.clipsToBounds = true
            if let imageURL = URL(string: data.imageURL?.safeUrl() ?? "") {
                self.imgView.kf.setImage(with: imageURL)
            }
            self.songTitleName.text = data.title
        }
    }
}
