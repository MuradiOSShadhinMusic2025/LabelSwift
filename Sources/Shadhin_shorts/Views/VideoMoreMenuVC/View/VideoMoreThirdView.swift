//
//  VideoMoreThirdView.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 12/5/25.
//

import UIKit

class VideoMoreThirdView: UIView {

    // MARK: -- Outlets --
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: -- Properties --
    var didTappedSubmitBtn: ((VideoMoreMenuItems) -> Void)?
    var didTappedCancelBtn: (() -> Void)?
    var didTappedBackBtn: (() -> Void)?
    var videoMenuItems = [VideoMoreMenuItems]() {
        didSet {
            if !videoMenuItems.isEmpty {
                self.collectionView.reloadData()
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
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func reportBackBtnAction(_ sender: UIButton) {
        self.didTappedBackBtn?()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.didTappedCancelBtn?()
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.didTappedSubmitBtn?(videoMenuItems[0])
    }
    
    
}

// MARK: -- Private Methods --

extension VideoMoreThirdView {

    private func commonInit() {
        Bundle.bundle.loadNibNamed("VideoMoreThirdView", owner: self, options: [:])
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        self.setupCollectionView()
        self.collectionView.contentInset = UIEdgeInsets(top: -55, left: 0, bottom: 40, right: 0)
        self.cancelButton.layer.cornerRadius = self.cancelButton.bounds.height/2
        self.submitButton.layer.cornerRadius = self.submitButton.bounds.height/2
        self.submitButton.titleLabel?.font = UIFont.inter(.medium, size: 16)
        self.cancelButton.titleLabel?.font = UIFont.inter(.medium, size: 16)
        self.submitButton.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.black, radius: 2.0, opacity: 0.25)
        self.cancelButton.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.black, radius: 2.0, opacity: 0.25)
        self.submitButton.layer.borderWidth = 0.8
        self.submitButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        self.cancelButton.layer.borderWidth = 0.8
        self.cancelButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ReportDetailsCell.nib, forCellWithReuseIdentifier: ReportDetailsCell.identifier)
        self.navTitleLabel.font = UIFont.circularStd(.book, size: 20)
    }
}


// MARK: ---- CollectionView Delegate Methods ----

extension VideoMoreThirdView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportDetailsCell.identifier, for: indexPath) as! ReportDetailsCell
        print("\(videoMenuItems.count)")
        cell.dataBind(data: videoMenuItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

