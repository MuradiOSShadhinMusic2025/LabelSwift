//
//  ExploreShortsCell.swift
//  Shadhin_shorts
//
//  Created by Maruf on 25/3/25.
//

import UIKit

class ExploreShortsCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var shortsContent = [ReelsContent]()
    var didTapShortsContent: ((Int) -> Void)?
    
    static var size: CGSize {
        let aspectRatio = 400.0/500.0 // h/w
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
            self.setupCollectionView()
        }

    }
    
    
    // MARK: - Actions
}


// MARK: - Private Methods
extension ExploreShortsCell {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ExploreShortsSubCell.nib, forCellWithReuseIdentifier: ExploreShortsSubCell.identifier)
    }
}


// MARK: - Collectionview Delegate Methods

extension ExploreShortsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shortsContent.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreShortsSubCell.identifier, for: indexPath) as? ExploreShortsSubCell else {
            fatalError()
        }
        cell.dataBind(data: shortsContent[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ExploreShortsSubCell.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapShortsContent?(shortsContent[indexPath.row].id ?? 0)
    }
}
