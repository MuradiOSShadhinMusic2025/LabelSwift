//
//  VideoMoreSecondView.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 12/5/25.
//

import UIKit

class VideoMoreSecondView: UIView {
    
    // MARK: -- Outlets --
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var navTitleLabel: UILabel!
    
    // MARK: -- Properties --
    var didTappedIndex: ((Int) -> Void)?
    var didTappedBackBtn: (() -> Void)?

    // MARK: -- Init() --
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [self] in
            commonInit()
        }

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func reportBackBtnAction(_ sender: UIButton) {
        self.didTappedBackBtn?()
    }
}

// MARK: -- Private Methods --

extension VideoMoreSecondView {
    
    private func commonInit() {
        Bundle.bundle.loadNibNamed("VideoMoreSecondView", owner: self, options: [:])
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        self.setupCollectionView()
        
        self.headerTitleLbl.font = UIFont.circularStd(.bold, size: 22)
        self.navTitleLabel.font = UIFont.circularStd(.book, size: 20)
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(VideoMoreMenuCell.nib, forCellWithReuseIdentifier: VideoMoreMenuCell.identifier)
        self.collectionView.reloadData()
    }
}


// MARK: ---- CollectionView Delegate Methods ----

extension VideoMoreSecondView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShadhinShort.shared.videoMenuSecondItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoMoreMenuCell.identifier, for: indexPath) as! VideoMoreMenuCell
        cell.dataBind(data: ShadhinShort.shared.videoMenuSecondItems[indexPath.item])
        cell.separatorView.isHidden = indexPath.item == ShadhinShort.shared.videoMenuSecondItems.count - 1
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTappedIndex?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return VideoMoreMenuCell.sizeSecond
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

