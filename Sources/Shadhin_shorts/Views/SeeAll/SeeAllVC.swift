//
//  SeeAllVCViewController.swift
//  Shadhin_shorts
//
//  Created by Maruf on 13/4/25.
//

import UIKit

class SeeAllVC: UIViewController, NIBVCProtocol {
    
    // MARK: - Outlets
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var navTitle : String = ""
    var shortsContent: [ReelsContent] = []
    private let viewModel = AudioReelsViewModel()
    var didTapShortsContent: ((Int) -> Void)?

    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle:Bundle.shadhinShorts)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navTitleLbl.text = navTitle
        collectionView
            .register(
                SeeAllCommonCell.nib,
                forCellWithReuseIdentifier: SeeAllCommonCell
                    .identifier)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension SeeAllVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shortsContent.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeAllCommonCell.identifier, for: indexPath) as? SeeAllCommonCell else {
            fatalError()
        }
        cell.dataBind(data: shortsContent[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        SeeAllCommonCell.sizeSeeAll
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapShortsContent?(shortsContent[indexPath.row].id ?? 0)
    }
}
