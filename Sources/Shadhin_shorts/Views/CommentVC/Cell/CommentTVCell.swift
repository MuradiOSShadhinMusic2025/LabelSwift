//
//  CommentTVCell.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 14/5/25.
//

import UIKit

class CommentTVCell: UITableViewCell {

    // MARK: ---- Outlets ----
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var replyViewBtn: UIButton!
    @IBOutlet weak var replyStackView: UIStackView!
    @IBOutlet weak var leadingConstant: NSLayoutConstraint!
    @IBOutlet weak var favStackView: UIStackView!
    @IBOutlet weak var extraButton: UIButton!
    
    // MARK: ---- Properties ----
    static let identifier = "CommentTVCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: .init(for: CommentTVCell.self))
    }
    static var height: CGFloat {
        return UITableView.automaticDimension
    }
    var isFavorite : Bool = false
    var didTappedReply : (() -> Void)?
    var didTappedViewAllReply : (() -> Void)?
    var didTappedFavorite : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: ---- Actions ----
    @IBAction func replyBtnActions(_ sender: UIButton) {
        self.didTappedReply?()
    }
    
    @IBAction func viewAllreplyBtnActions(_ sender: UIButton) {
        self.didTappedViewAllReply?()
    }
    
    @IBAction func favoriteBtnActions(_ sender: UIButton) {
        self.didTappedFavorite?()
    }
}


// MARK: ---- Private Methods ----
extension CommentTVCell {
    private func setupCellUI() {
        self.timeAgo.font = UIFont.inter(.regular, size: 12)
        self.userName.font = UIFont.inter(.bold, size: 16)
        self.comment.font = UIFont.inter(.regular, size: 14)
        self.favBtn.titleLabel?.font = UIFont.inter(.regular, size: 14)
        self.replyBtn.titleLabel?.font = UIFont.inter(.bold, size: 14)
        self.replyViewBtn.titleLabel?.font = UIFont.inter(.bold, size: 14)
        self.selectionStyle = .none
    }
    
    func commentDataBind(data: ShortsComment) {
        if data.imageUrl.isEmpty {
            self.userImg.image = data.fullName.letterAvatar()
        } else {
            self.userImg.kf.setImage(with: URL(string: data.imageUrl))
        }
        self.isFavorite = data.isFavorite == 1
        self.timeAgo.text = ShadhinShort.shared.formattedTimeAgo(from: data.createdAt)
        self.userName.text = data.fullName
        self.comment.text = data.description
        self.leadingConstant.constant = 14
        self.extraButton.isHidden = true
        self.replyBtn.isHidden = false
        self.favBtn.setImage((data.isFavorite != 0) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        self.favBtn.tintColor = (data.isFavorite != 0) ? .red : .topBarModeType
        self.favBtn.setTitle(data.reactionCount.formattedCount, for: .normal)
        self.replyStackView.isHidden = data.replyCount == 0
        self.replyViewBtn.setTitle("\(data.replyCount > 1 ? "\(data.replyCount.formattedCount) Replies" : "1 Reply")", for: .normal)
    }
    
    func replyDataBind(data: ShortsReply?) {
        if ((data?.imageUrl.isEmpty) != nil) {
            self.userImg.image = data?.fullName.letterAvatar()
        } else {
            self.userImg.kf.setImage(with: URL(string: data?.imageUrl ?? ""))
        }
        self.leadingConstant.constant = 60
        self.timeAgo.text = ShadhinShort.shared.formattedTimeAgo(from: data?.createdAt ?? "")
        self.userName.text = data?.fullName
        self.comment.text = data?.description
        self.favBtn.setTitle(data?.reactionCount.formattedCount, for: .normal)
        self.favBtn.setImage((data?.isFavorite != 0) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        self.isFavorite = data?.isFavorite == 1
        self.favBtn.tintColor = (data?.isFavorite != 0) ? .red : .topBarModeType
        self.replyStackView.isHidden = true
        self.replyBtn.isHidden = true
        self.extraButton.isHidden = false
        self.extraButton.alpha = 0
    }
    
    func addCommentFavorite(data: inout ShortsComment) {
        if isFavorite {
            data.reactionCount -= 1
            data.isFavorite = 0
            self.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            self.favBtn.tintColor = .topBarModeType
        } else {
            data.reactionCount += 1
            data.isFavorite = 1
            self.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.favBtn.tintColor = .red
        }

        self.favBtn.setTitle(data.reactionCount.formattedCount, for: .normal)
        self.isFavorite = (data.isFavorite == 1)
    }
    
    func addReplyFavorite(data: inout ShortsReply) {
        if isFavorite {
            data.reactionCount -= 1
            data.isFavorite = 0
            self.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            self.favBtn.tintColor = .topBarModeType
        } else {
            data.reactionCount += 1
            data.isFavorite = 1
            self.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.favBtn.tintColor = .red
        }

        self.favBtn.setTitle(data.reactionCount.formattedCount, for: .normal)
        self.isFavorite = (data.isFavorite == 1)
    }
}
