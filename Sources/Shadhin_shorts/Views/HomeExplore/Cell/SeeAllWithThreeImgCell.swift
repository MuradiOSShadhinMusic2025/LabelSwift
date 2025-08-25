//
//  SeeAllWithThreeImgCell.swift
//  Shadhin_shorts
//
//  Created by Maruf on 6/4/25.
//

import UIKit

class SeeAllWithThreeImgCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var seeAllbtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var shortsContent: [ReelsContent] = []
    var didTapShortsContent: ((Int) -> Void)?
    var onTap: (() -> Void) = {}
    
    static var size: CGSize {
        let designWidth: CGFloat = 360.0
        let designHeight: CGFloat = 490.0
        let aspectRatio = designHeight/designWidth // h/w
        let width = DEVICE_WIDTH - 16
        let height = width/aspectRatio
        return CGSize(width: width, height: height)
    }

    static var identifier : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.UISetup()
        }
    }
    
    @IBAction func seeAllBtnClicked(_ sender: Any) {
        onTap()
    }
    
    private func UISetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SeeAllWithThreeImgSubCell.nib,forCellWithReuseIdentifier: SeeAllWithThreeImgSubCell.identifier)
    }
    
    func dataBind() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SeeAllWithThreeImgCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shortsContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeAllWithThreeImgSubCell.identifier, for: indexPath) as? SeeAllWithThreeImgSubCell else {
            fatalError()
        }
        cell.dataBind(data: shortsContent[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SeeAllWithThreeImgSubCell.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapShortsContent?(shortsContent[indexPath.row].id ?? 0)
    }
}

