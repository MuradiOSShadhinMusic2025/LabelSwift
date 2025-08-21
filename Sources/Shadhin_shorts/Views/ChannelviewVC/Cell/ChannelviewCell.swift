
//
//  ChannelviewCell.swift
//  Shadhin_shorts
//
//  Created by MD Murad Hossain on 29/4/25.
//

import UIKit

class ChannelviewCell: UICollectionViewCell {

    // MARK: ---- Outlets ----
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var isVerifiedImgView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var followerTextLabel: UILabel!
    @IBOutlet weak var likesTextLabel: UILabel!
    @IBOutlet weak var viewsTextLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var followerStackView: UIStackView!
    @IBOutlet weak var likesStackView: UIStackView!
    @IBOutlet weak var viewsStackView: UIStackView!
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var dotLabelTwo: UILabel!
    @IBOutlet weak var followNShareBtnStackView: UIStackView!
    
    // MARK: ---- Properties ----
    static var identifier : String{
        return String(describing: self)
    }
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    var isHashtag: Bool = false
    var didTappedFollow: (() -> Void)?
    var didTappedShare: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupUI()
    }
    
    // MARK: --- Actions ---
    
    @IBAction func followBtnTapped(_ sender: UIButton) {
        let currentTitle = followBtn.title(for: .normal)
        let currentCount = Int(self.followerCountLabel.text ?? "0") ?? 0
        let newTitle = (currentTitle == "Follow") ? "Following" : "Follow"
        if (currentTitle == "Follow") {
            self.followBtn.titleLabel?.pushTransition(0.25, direction: .fromTop)
            ShadhinShort.shared.isProfileFollow = false
        } else {
            self.followBtn.titleLabel?.pushTransition(0.25, direction: .fromBottom)
            ShadhinShort.shared.isProfileFollow = true
        }
        self.followBtn.setTitle(newTitle, for: .normal)
        self.followerCountLabel.text = (currentTitle == "Follow") ? (currentCount + 1).formattedCount : (currentCount - 1).formattedCount
        self.didTappedFollow?()
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        self.didTappedShare?()
    }
    
    
    // MARK: --- Pivate Methods ---
    private func setupUI() {
        
        self.followBtn.layer.cornerRadius = self.followBtn.bounds.height/2
        self.shareBtn.layer.cornerRadius = self.shareBtn.bounds.height/2
        self.shareBtn.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.25)
        self.followBtn.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.25)
        self.channelNameLabel.font = UIFont.circularStd(.medium, size: 22)
        self.followerCountLabel.font = UIFont.inter(.bold, size: 16)
        self.likesCountLabel.font = UIFont.inter(.bold, size: 16)
        self.likesCountLabel.font = UIFont.inter(.bold, size: 16)
        self.shareBtn.titleLabel?.font = UIFont.inter(.medium, size: 16)
        self.followBtn.titleLabel?.font = UIFont.inter(.medium, size: 16)
        self.followerTextLabel.font = UIFont.inter(.regular, size: 14)
        self.likesTextLabel.font = UIFont.inter(.regular, size: 14)
        self.viewsTextLabel.font = UIFont.inter(.regular, size: 14)
    }
    
    func dataBindCell(data: ChannelHeaderData?) {
        
        if isHashtag {
            self.channelImage.image = UIImage(named: "hashtagimage")
            self.channelImage.layer.cornerRadius = 0.0
            self.followNShareBtnStackView.isHidden = true
            self.isVerifiedImgView.isHidden = true
            self.followerTextLabel.text = "Posts"
            self.likesTextLabel.text = "Views"
            self.viewsTextLabel.text = "Users"
            self.dotLabelTwo.isHidden = false
            self.dotLabel.isHidden = false

            if data?.analytics.contributorsCount ?? 0 <= 0 {
                self.viewsStackView.isHidden = true
                self.isVerifiedImgView.isHidden = true
                self.dotLabelTwo.isHidden = true
                self.channelNameLabel.text = "#\(data?.title ?? "")"
                self.followerCountLabel.text = "\(data?.analytics.reelsCount?.formattedCount ?? "")"
                self.likesCountLabel.text = "\(data?.analytics.viewsCount?.formattedCount ?? "")"
            }
            
            self.dotLabel.isHidden = false
            self.channelNameLabel.text = "#\(data?.title ?? "")"
            self.followerCountLabel.text = "\(data?.analytics.reelsCount?.formattedCount ?? "")"
            self.likesCountLabel.text = "\(data?.analytics.viewsCount?.formattedCount ?? "")"
            self.viewsCountLabel.text = "\(data?.analytics.contributorsCount?.formattedCount ?? "")"
        }
        
        else {
            self.followNShareBtnStackView.isHidden = false
            self.followerStackView.isHidden = false
            self.dotLabel.isHidden = false
            self.channelImage.layer.cornerRadius = self.channelImage.bounds.height/2
            if let imageUrlString = data?.imageUrl.image450, !imageUrlString.isEmpty, let url = URL(string: imageUrlString) {
                self.channelImage.kf.setImage(with: url)
            } else {
                self.channelImage.image = UIImage(named: "channelPlaceholderImg")
            }
            self.followBtn.setTitle(ShadhinShort.shared.isProfileFollow ? "Following" : "Follow", for: .normal)
            self.followerTextLabel.text = "Followers"
            self.likesTextLabel.text = "Likes"
            self.viewsTextLabel.text = "Views"
            self.isVerifiedImgView.isHidden = !(data?.isVerified ?? false)
            self.channelNameLabel.text = "@\(data?.title ?? "")"
            self.followerCountLabel.text = "\(data?.analytics.followersCount?.formattedCount ?? "")"
            self.likesCountLabel.text = "\(data?.analytics.favoritesCount?.formattedCount ?? "")"
            self.viewsCountLabel.text = "\(data?.analytics.viewsCount?.formattedCount ?? "")"
        }
    }
}
