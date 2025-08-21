//
//  SeeAllWithThreeImgSubCell.swift
//  Shadhin_shorts
//
//  Created by Maruf on 6/4/25.
//

import UIKit

class SeeAllWithThreeImgSubCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var songTitleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var gradientImgView: UIImageView!
    
    // MARK: - Properties
    static var size: CGSize {
        let designWidth: CGFloat = 148.0
        let designHeight: CGFloat = 230.0
        let aspectRatio = designHeight / designWidth
        let availableWidth = DEVICE_WIDTH - 16
        let cellWidth = availableWidth / 2.5
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
extension SeeAllWithThreeImgSubCell {
    
    private func setupCellUI() {
        self.gradientImgView.layer.cornerRadius = 10
        self.gradientImgView.clipsToBounds = true
        self.gradientImgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func dataBind(data: ReelsContent) {
        DispatchQueue.main.async {
            self.imgView.layer.cornerRadius = 10
            self.imgView.clipsToBounds = true
            if let imageURL = URL(string: data.imageURL?.image300 ?? "") {
                self.imgView.kf.setImage(with: imageURL)
            }
            self.songTitleLbl.text = data.title
        }
    }
}
