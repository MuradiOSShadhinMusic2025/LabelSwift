//
//  ReplyView.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 18/5/25.
//

import UIKit

class ReplyView: UIView {
    
    // MARK: -- Outlets --
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: -- Properties --
    var didTappedIndex: ((Int) -> Void)?
    var commentData: ShortsComment?
    var replyAllData: [ShortsReply] = [] {
        didSet {
            if !replyAllData.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: -- Init() --
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.commonInit()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: -- Private Methods --

extension ReplyView {

    private func commonInit() {
        Bundle.bundle.loadNibNamed("ReplyView", owner: self, options: [:])
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CommentTVCell.nib(), forCellReuseIdentifier: CommentTVCell.identifier)
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        self.tableView.estimatedRowHeight = 50
        self.tableView.showsVerticalScrollIndicator = false
    }
}


// MARK: ---- TableView Delegate Methods ----

extension ReplyView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return replyAllData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTVCell.identifier, for: indexPath) as! CommentTVCell
        switch indexPath.section {
        case 0:
            if var commentData = self.commentData {
                cell.commentDataBind(data: commentData)
                cell.replyStackView.isHidden = true
                cell.replyBtn.isHidden = true
                cell.extraButton.isHidden = false
                cell.extraButton.alpha = 0
                cell.didTappedFavorite = {
                    cell.addCommentFavorite(data: &commentData)
                    ShadhinShortsApi.shared.addCommentOrReplyFavorite(commentId: commentData.commentId,
                                                                      replyId: nil,
                                                                      isLiked: commentData.isFavorite == 1,
                                                                      usercode: "8801717230976") { data, error in
                        if let data = data?.data {
                            print(data)
                        }
                    }
                }

            }
        case 1:
            cell.replyDataBind(data: replyAllData[indexPath.row])
            cell.didTappedFavorite = {[self] in
                cell.addReplyFavorite(data: &replyAllData[indexPath.row])
                ShadhinShortsApi.shared.addCommentOrReplyFavorite(commentId: nil,
                                                                  replyId: replyAllData[indexPath.row].replyId,
                                                                  isLiked: replyAllData[indexPath.row].isFavorite == 1,
                                                                  usercode: "8801717230976") { data, error in
                    if let data = data?.data {
                        print(data)
                    }
                }
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentTVCell.height
    }
}



