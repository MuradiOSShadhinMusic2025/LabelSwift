//
//  CommentVC.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 13/5/25.
//

import UIKit
import SwiftEntryKit

class CommentVC: UIViewController, NIBVCProtocol {

    // MARK: ---- Outlets ----
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textBgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowBgView: UIView!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyStackView: UIStackView!
    @IBOutlet weak var replyToNameLabel: UILabel!
    @IBOutlet weak var replyView: ReplyView!
    @IBOutlet weak var replyViewLeading: NSLayoutConstraint!
    @IBOutlet weak var commentTableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noMoreCommentLabel: UILabel!
    
    // MARK: ---- Properites ----
    var commentsData = [ShortsComment]() {
        didSet {
            if !self.commentsData.isEmpty {
                self.noMoreCommentLabel.isHidden = true
                self.tableView.reloadData()
            } else {
                self.noMoreCommentLabel.isHidden = false
            }
        }
    }
    var reelsContent: ReelsContent?
    var replyData = [ShortsReply]()
    var isShowKeyboard: Bool = false
    var keyboardHeight: CGFloat = 0.0
    var keyboardShowTime : Float = 0.0
    var previewtxtViewHeight : CGFloat = 0.0
    var textBgViewMaxHeight : CGFloat = 152.0
    var textBgViewMinHeight : CGFloat = 112.0
    var textviewMaxHeight : CGFloat = 100.0
    
    var sendMessage : ((String) -> Void)?
    private var lastContentOffset: CGFloat = 0
    private var scrollDirectionIsDown: Bool = true
    var repliesData : ShortsComment? = nil
    var replyIndexPath = IndexPath()
    var isCellAnimation : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
    }
        
    // MARK: ---- Actions ----
    
    @IBAction func didmissButton(_ sender: Any) {
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func replyCrossButton(_ sender: UIButton) {
        DispatchQueue.main.async { [self] in
            self.isReplyViewShow(isShow: false)
            self.repliesData = nil
            let padding = textView.text.isEmpty ? CGFloat(44) : CGFloat(10)
            textView.textContainerInset = UIEdgeInsets(top: 12, left: padding, bottom: 12, right: 50)
            UIView.animate(withDuration: 0.3) { [self] in
                self.textBgViewMinHeight = 112
                self.textBgViewMaxHeight = 152
                self.titleLabel.text = "Comments"
                self.placeHolderLabel.text = "Write your comment"
                self.replyStackView.isHidden = true
                self.textViewBorderColorChage(isActive: false)
                self.view.endEditing(true)
                let calculate = (textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height) - self.previewtxtViewHeight
                self.textBgViewHeight.constant = min((calculate > 0 ? calculate : 0) + self.textBgViewMinHeight, self.textBgViewMaxHeight)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.sendButton.isEnabled = false
        if let repliesData = repliesData {
            self.addReplyingMessage(repliesData: repliesData)
        } else {
            self.addCommentMessage()
        }
    }
}


// MARK: ---- Private Methods ----

extension CommentVC {
    
    private func addReplyingMessage(repliesData: ShortsComment) {
        self.isCellAnimation = true
        ShadhinShortsApi.shared.addRepliesData(contentId: repliesData.commentId,
                                               description: textView.text,
                                               usercode: "GH9001892981",
                                               fullName: "Mosharraf Karim",
                                               imageUrl: "") { [self] data, error in
            self.sendButton.isEnabled = true
            
            if let error = error {
                self.view.makeToast(error.localizedDescription)
            }
            if let _ = data?.data {
                self.textView.text = ""
                self.textViewCheckTheEmtyText(text: textView.text)
                self.commentsData[self.replyIndexPath.row].replyCount += 1
                self.tableView.reloadRows(at: [self.replyIndexPath], with: .none)
                let calculate = (textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height) - self.previewtxtViewHeight
                self.textBgViewHeight.constant = min((calculate > 0 ? calculate : 0) + self.textBgViewMinHeight, self.textBgViewMaxHeight)
            }
            self.isCellAnimation = false
        }
    }
    
    private func addCommentMessage() {
        ShadhinShortsApi.shared.addCommentsData(contentId: reelsContent?.id ?? 0,
                                                usercode: "8801717230976",
                                                description: textView.text,
                                                fullName: "Rezwan DEV",
                                                imageUrl: "") { data, error in
            self.sendButton.isEnabled = true
            
            if let error = error {
                self.view.makeToast(error.localizedDescription)
            }
            
            self.scrollDirectionIsDown = false
            self.lastContentOffset = 0
            guard let newComment = data?.data else { return }
            
            DispatchQueue.main.async { [self] in
                self.textView.text = ""
                self.textViewCheckTheEmtyText(text: textView.text)
                let calculate = (textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height) - self.previewtxtViewHeight
                self.textBgViewHeight.constant = min((calculate > 0 ? calculate : 0) + self.textBgViewMinHeight, self.textBgViewMaxHeight)
                self.tableView.beginUpdates()
                if self.commentsData.count > 0 {
                    self.commentsData.insert(newComment, at: 0)
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                } else {
                    self.commentsData.append(newComment)
                    self.tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                self.tableView.endUpdates()
            }
        }
    }
    
    private func setupUI() {
        
        self.replyStackView.isHidden = true
        self.replyToNameLabel.font = UIFont.inter(.regular, size: 16)
        self.commentTableViewLeading.constant = 0
        self.replyViewLeading.constant = DEVICE_WIDTH
        /// Textview
        self.textView.isScrollEnabled = true
        self.shadowBgView.layer.cornerRadius = 8
        self.textView.font = UIFont.inter(.regular, size: 16)
        self.placeHolderLabel.font = UIFont.inter(.regular, size: 14)
        self.titleLabel.font = UIFont.circularStd(.bold, size: 24)
        self.textView.delegate = self
        self.textBgViewHeight.constant = self.textBgViewMinHeight
        self.previewtxtViewHeight = textView.bounds.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height
        UITextView.appearance().tintColor = UIColor.bgBtnColor
        self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 50)
        self.placeHolderLabel.isHidden = false
        self.messageIcon.isHidden = false
        self.bgView.layer.cornerRadius = 24
        self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bgView.clipsToBounds = true
        self.sendButton.isEnabled = false
        self.setupKeyboardNotification()
        self.textViewBorderColorChage(isActive: false)
    }
    
    private func textViewBorderColorChage(isActive: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isActive {
                self.shadowBgView.backgroundColor = .textViewBgColor
                self.shadowBgView.layer.borderColor = UIColor.bgBtnColor.cgColor
                self.shadowBgView.layer.borderWidth = 1
                self.shadowBgView.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.bgBtnColor, radius: 5.0, opacity: 0.3)
            } else {
                self.shadowBgView.backgroundColor = .textViewBgColor
                self.shadowBgView.layer.borderColor = UIColor.topBarModeTypeColor.withAlphaComponent(0.3).cgColor
                self.shadowBgView.layer.borderWidth = 1
                self.shadowBgView.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.topBarModeTypeColor, radius: 5.0, opacity: 0.3)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func textViewCheckTheEmtyText(text: String) {
        UIView.animate(withDuration: 0.3) {
            if text.count > 0 {
                self.sendButton.isEnabled = true
                self.sendButton.setBackgroundImage(UIImage(named: "activeSendBtn"), for: .normal)
                self.placeHolderLabel.isHidden = true
                self.messageIcon.isHidden = true
            } else {
                self.sendButton.isEnabled = false
                self.sendButton.setBackgroundImage(UIImage(named: "deActiveSendBtn"), for: .normal)
                self.placeHolderLabel.isHidden = false
                self.messageIcon.isHidden = false
            }
            
            self.view.layoutIfNeeded()
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CommentTVCell.nib(), forCellReuseIdentifier: CommentTVCell.identifier)
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        self.tableView.estimatedRowHeight = 120
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    public static func shows(safeArea: CGFloat = 0, commentData: [ShortsComment], reelsContent: ReelsContent?) {
        let vc = CommentVC.instantiateNib()
        var attributes = SwiftEntryKitAttributes.bottomFullScAlertAttributes()
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.3)))
        attributes.shadow = .none
        attributes.displayDuration = .infinity
        attributes.position = .bottom
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.statusBar = .dark
        attributes.positionConstraints.verticalOffset = -safeArea
        SwiftEntryKit.display(entry: vc, using: attributes)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            vc.commentsData = commentData
            vc.reelsContent = reelsContent
        }
    }
    
    private func isReplyViewShow(isShow: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isShow {
                self.commentTableViewLeading.constant = -DEVICE_WIDTH
                self.replyViewLeading.constant = 0
            } else {
                self.commentTableViewLeading.constant = 0
                self.replyViewLeading.constant = DEVICE_WIDTH
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: ---- Keyboard Notification Methods ----
extension CommentVC {
    private func setupKeyboardNotification() {
         self.keyboardTapToDismiss()
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
     private func getTheKeyboardHeight(notifi: Notification) -> CGFloat? {
         if let userInfo = notifi.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
             self.keyboardShowTime = Float(duration)
             if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                 let keyboardRectangle = keyboardFrame.cgRectValue
                 let keyboardHeight = keyboardRectangle.height
                 return keyboardHeight
             }
         }
         return nil
     }
     
     private func keyboardTapToDismiss() {
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
         tap.cancelsTouchesInView = true
         view.addGestureRecognizer(tap)
     }
    
    @objc private func dismissKeyboardAction() {
        view.endEditing(true)
        self.textViewBorderColorChage(isActive: false)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let height = self.getTheKeyboardHeight(notifi: notification) {
            self.isShowKeyboard = true
            self.keyboardHeight = height
            self.keyboardHeight = 0
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.isShowKeyboard = false
        self.keyboardHeight = 0.0
    }
}


// MARK: ---- TableView Delegate Methods ----
extension CommentVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var commentData = commentsData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTVCell.identifier, for: indexPath) as! CommentTVCell
        cell.commentDataBind(data: commentData)
        
        cell.didTappedReply = {
            DispatchQueue.main.async { [self] in

                self.repliesData = commentData
                self.replyIndexPath = indexPath
                self.textView.becomeFirstResponder()
                let padding = textView.text.isEmpty ? CGFloat(44) : CGFloat(10)
                textView.textContainerInset = UIEdgeInsets(top: 12, left: padding, bottom: 12, right: 50)

                UIView.animate(withDuration: 0.3) { [self] in
                    self.textBgViewMinHeight = 138
                    self.textBgViewMaxHeight = 178
                    self.replyStackView.isHidden = false
                    self.titleLabel.text = "Replies"
                    self.placeHolderLabel.text = "Write your reply"
                    self.replyToNameLabel.setBoldText(fullText: "Replying to \(commentData.fullName)", boldPart: commentData.fullName)
                    let calculate = (textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height) - self.previewtxtViewHeight
                    self.textBgViewHeight.constant = min((calculate > 0 ? calculate : 0) + self.textBgViewMinHeight, self.textBgViewMaxHeight)
                    self.view.layoutIfNeeded()
                }
            }
        }
        
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
        
        cell.didTappedViewAllReply = {
            self.activityIndicator.startAnimating()
            self.replyView.commentData = commentData
            
            ShadhinShortsApi.shared.getAllRepliessData(commentId: commentData.commentId, usercode: "8801717230976") { data, error in
                if let data = data?.data {
                    let sortedData = data.map { $0 }.sorted { $0.createdAt > $1.createdAt }
                    self.activityIndicator.stopAnimating()
                    DispatchQueue.main.async { [self] in
                        self.replyView.replyAllData = sortedData
                        let padding = textView.text.isEmpty ? CGFloat(44) : CGFloat(10)
                        textView.textContainerInset = UIEdgeInsets(top: 12, left: padding, bottom: 12, right: 50)
                        self.isReplyViewShow(isShow: true)

                        UIView.animate(withDuration: 0.3) { [self] in
                            self.textBgViewMinHeight = 138
                            self.textBgViewMaxHeight = 178
                            self.replyStackView.isHidden = false
                            self.titleLabel.text = "Replies"
                            self.placeHolderLabel.text = "Add a reply"
                            self.replyToNameLabel.setBoldText(fullText: "View all replies", boldPart: "")
                            let calculate = (textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height) - self.previewtxtViewHeight
                            self.textBgViewHeight.constant = min((calculate > 0 ? calculate : 0) + self.textBgViewMinHeight, self.textBgViewMaxHeight)
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    self.view.makeToast(error.localizedDescription, position: .center, title: "Error")
                }
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentTVCell.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isCellAnimation {
            let translationY: CGFloat = scrollDirectionIsDown ? 50 : -50
            cell.transform = CGAffineTransform(translationX: 0, y: translationY)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0.02 * Double(indexPath.row), options: [.curveEaseOut], animations: {
                cell.transform = .identity
                cell.alpha = 1
            }, completion: nil)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > lastContentOffset {
            scrollDirectionIsDown = true
        } else {
            scrollDirectionIsDown = false
        }
        lastContentOffset = scrollView.contentOffset.y
    }
}


// MARK: ---- TextView Delegate Methods ----

extension CommentVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.previewtxtViewHeight = textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height
        self.textViewBorderColorChage(isActive: true)
        let padding = textView.text.isEmpty ? CGFloat(44) : CGFloat(10)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: padding, bottom: 12, right: 50)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.textViewCheckTheEmtyText(text: textView.text)
        let padding = textView.text.isEmpty ? CGFloat(44) : CGFloat(10)

        UIView.animate(withDuration: 0.3) {
            textView.textContainerInset = UIEdgeInsets(top: 12, left: padding, bottom: 12, right: 50)
            let calculate = (textView.contentSize.height >  self.textviewMaxHeight ? self.textviewMaxHeight : textView.contentSize.height) - self.previewtxtViewHeight
            self.textBgViewHeight.constant = min((calculate > 0 ? calculate : 0) + self.textBgViewMinHeight, self.textBgViewMaxHeight)
            self.view.layoutIfNeeded()
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        let padding = textView.text.isEmpty ? CGFloat(44) : CGFloat(10)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: padding, bottom: 12, right: 50)
    }
}
