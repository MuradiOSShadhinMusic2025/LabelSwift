//
//  SocialMediaCell.swift
//  Shadhin_shorts
//
//  Created by MD Murad Hossain on 29/4/25.
//

import UIKit

class SocialMediaCell: UICollectionViewCell {

    // MARK: ---- Outlets ----
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaNameLabel: UILabel!
    
    // MARK: ---- Properties ----
    static var identifier : String{
        return String(describing: self)
    }
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.mediaNameLabel.font = UIFont.inter(.regular, size: 14)
    }
    
    func dataBindCell(data: SocialMediaLink?) {
        if data?.socialMediaName.lowercased() == "facebook" {
            self.mediaNameLabel.text = "Facebook"
            self.mediaImageView.image = UIImage(named: "facebookImg")
        } else if data?.socialMediaName.lowercased() == "instagram" {
            self.mediaNameLabel.text = "Instagram"
            self.mediaImageView.image = UIImage(named: "instagramImg")
        } else if data?.socialMediaName.lowercased() == "youtube" {
            self.mediaNameLabel.text = "YouTube"
            self.mediaImageView.image = UIImage(named: "youtubeImg")
        }
    }
}
