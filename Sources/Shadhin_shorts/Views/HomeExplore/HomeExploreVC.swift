//
//  HomeExoloreVC.swift
//  Shadhin_shorts
//
//  Created by Maruf on 25/3/25.
//

import UIKit

public enum HomeExplorePatchType: Int {
    case EXPLORE_SHORTS     = 2002
    case RECOMANDED_SHORTS  = 2003
    case NEW_MUSIC          = 2008
    case UNKNOWN            = -1
    
    public init(rawValue: Int) {
        switch rawValue {
        case 2002: self = .EXPLORE_SHORTS
        case 2003: self = .RECOMANDED_SHORTS
        case 2008: self = .NEW_MUSIC
        default: self = .UNKNOWN
        }
    }
}

public class HomeExploreVC: UIViewController, NIBVCProtocol {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var exploreBtn: UIButton!
    @IBOutlet weak var forYouBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var navBtnStackView: UIStackView!
    @IBOutlet weak var shortsPlayBgView: UIView!
    
    // MARK: - Properties
    var titleText: String?
    private let viewModel = AudioReelsViewModel()
    var audioReelsData: ReelsResponseObject?
    var audioReelsContent = [ReelsContent]()
    var allFavoriteData = [Favorite]()
    
    static var identifier : String {
        return String(describing: self)
    }
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewModelBindings()
        self.fetchAllFavoriteData()
        self.forYouReelsDataBinding(isBool: true)
        self.viewSetup()
        self.viewModel.fetchAudioReels()
        self.title = titleText
        self.viewModel.onDataReceived = { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.audioReelsData = response
                self.audioReelsData?.data?.sort { ($0.sort ?? 0) < ($1.sort ?? 0) }
                self.collectionView.reloadData()
            }
        }
    }
        
    // MARK: - Actions
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        print("Did tap Cross Button")
        self.fetchAllFavoriteData()
    }
    
    @IBAction func exploreBtnAction(_ sender: UIButton) {
        self.fetchAllFavoriteData()
        self.crossBtn.isHidden = true
        self.navBtnStackView.spacing = 12
        self.shortsPlayCatBtnSelected(button: [self.exploreBtn, self.forYouBtn, self.followingBtn])
        self.removeShortsPlayerVC()
        self.forYouReelsDataBinding(isBool: false)
        self.navStackViewTextColorChange(isBool: false)
    }

    @IBAction func forYouBtnAction(_ sender: UIButton) {
        self.fetchAllFavoriteData()
        self.crossBtn.isHidden = false
        self.navBtnStackView.spacing = 5
        self.shortsPlayCatBtnSelected(button: [self.forYouBtn, self.exploreBtn, self.followingBtn])
        self.navStackViewTextColorChange(isBool: true)
        self.gotoShortsPlayerVC(data: self.audioReelsContent)
    }

    @IBAction func followingBtnAction(_ sender: UIButton) {
        self.fetchAllFavoriteData()
        self.crossBtn.isHidden = false
        self.navBtnStackView.spacing = 5
        self.forYouReelsDataBinding(isBool: false)
        self.shortsPlayCatBtnSelected(button: [self.followingBtn, self.exploreBtn, self.forYouBtn])
        self.removeShortsPlayerVC()
        self.navStackViewTextColorChange(isBool: false)
    }
}


// MARK: - Private Methods
extension HomeExploreVC {
    private func viewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ExploreShortsCell.nib,forCellWithReuseIdentifier:ExploreShortsCell.identifier)
        collectionView.register(SeeAllWithThreeImgCell.nib,forCellWithReuseIdentifier:SeeAllWithThreeImgCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
        self.shortsPlayCatBtnSelected(button: [self.forYouBtn, self.exploreBtn, self.followingBtn])
        self.shortsPlayBgView.isHidden = true
        self.navStackViewTextColorChange(isBool: true)
    }
    
    // ViewModel Data Binding
    private func setupViewModelBindings() {
        viewModel.onLoading = { isLoading in
            if isLoading {
                self.indicator.isHidden = false
                self.indicator.startAnimating()
            } else {
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
            }
        }
    }
    
    private func fetchAllFavoriteData() {
        self.viewModel.fetchAllFavoriteData()
        self.viewModel.onAllFavDataReceived = { [weak self] response in
            guard let self = self else { return }
            if let data = response {
                self.allFavoriteData = data
            }
        }
    }
    
    private func shortsPlayCatBtnSelected(button: [UIButton]) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            button[0].titleLabel?.font = UIFont.circularStd(.bold, size: 18)
            button[1].titleLabel?.font = UIFont.inter(.medium, size: 16)
            button[2].titleLabel?.font = UIFont.inter(.medium, size: 16)
        }
    }
    
    private func gotoShortsPlayerVC(data: [ReelsContent], indexPath: IndexPath = [0, 0] ){
//        let vc = ShortsPlayerVC(nibName: "ShortsPlayerVC", bundle: Bundle(for: ShortsPlayerVC.self))
        
        let vc = ShortsPlayerVC(nibName: "ShortsPlayerVC", bundle: .module)

        vc.audioReelsData = data
//        vc.selectedIndexPath = indexPath
//        vc.allFavoriteData = allFavoriteData
        self.addChild(vc)
        vc.view.frame = shortsPlayBgView.bounds
        self.shortsPlayBgView.isHidden = false
        self.shortsPlayBgView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    private func removeShortsPlayerVC() {
        for child in children {
            if let vc = child as? ShortsPlayerVC {
                vc.willMove(toParent: nil)
                self.shortsPlayBgView.isHidden = true
//                vc.cleanUpCache(excluding: [])
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
        }
    }
    
    private func navStackViewTextColorChange(isBool: Bool) {
        if isBool {
            self.crossBtn.tintColor = .white
            self.forYouBtn.setTitleColor(.white, for: .normal)
            self.followingBtn.setTitleColor(.white, for: .normal)
            self.exploreBtn.setTitleColor(.white, for: .normal)
        } else {
            self.crossBtn.tintColor = .textColorModeTypeColor
            self.forYouBtn.setTitleColor(.textColorModeTypeColor, for: .normal)
            self.followingBtn.setTitleColor(.textColorModeTypeColor, for: .normal)
            self.exploreBtn.setTitleColor(.textColorModeTypeColor, for: .normal)
        }
    }
    
    private func forYouReelsDataBinding(isBool: Bool) {
        self.viewModel.fetchForYouAudioReels()
        self.viewModel.onForYouDataReceived = { [weak self] response in
            guard let self = self else { return }
            if let data = response.data {
                self.audioReelsContent = data
                if isBool {
                    self.gotoShortsPlayerVC(data: data)
                }
            }
        }
    }
}


// MARK: - CollectionView Delegate Methods

extension HomeExploreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audioReelsData?.data?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = audioReelsData?.data, indexPath.row < data.count else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
        }

    
        let item = data[indexPath.row]
        let patchType = item.getDesignShorts()

        switch patchType {
        case .EXPLORE_SHORTS:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreShortsCell.identifier,
                for: indexPath) as? ExploreShortsCell else {
                fatalError("ExploreShortsCell not found")
            }
            // Optionally configure the cell here using `item`
            cell.titleLbl.text = item.title
            if let item = item.contents {
                cell.shortsContent = item
                cell.didTapShortsContent = { id in
                    if let index = item.firstIndex(where: { $0.id == id }) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.didTapShortContentsCell(item: item, indexPath: indexPath)
                    } else {
                        print("ID not found in contents")
                    }
                }
            }
            return cell

        case .RECOMANDED_SHORTS, .NEW_MUSIC:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SeeAllWithThreeImgCell.identifier,
                for: indexPath) as? SeeAllWithThreeImgCell else {
                fatalError("SeeAllWithThreeImgCell not found")
            }
            
            cell.titleLbl.text = patchType.rawValue == 1008 ?  "#"+(item.title ?? "") : item.title
            cell.dataBind()
            cell.onTap = { [weak self] in
                guard let self = self else { return }
                let vc = SeeAllVC.instantiateNib()
                if let item = item.contents {
                    vc.shortsContent = item
                    vc.didTapShortsContent = { id in
                        if let index = item.firstIndex(where: { $0.id == id }) {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.didTapShortContentsCell(item: item, indexPath: indexPath)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("ID not found in contents")
                        }
                    }
                }
                vc.navTitle = "\(item.title ?? "")"
                self.navigationController?
                    .pushViewController(vc, animated: true)
            }

            if let item = item.contents {
                cell.shortsContent = item
                cell.didTapShortsContent = { id in
                    if let index = item.firstIndex(where: { $0.id == id }) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.didTapShortContentsCell(item: item, indexPath: indexPath)
                    } else {
                        print("ID not found in contents")
                    }
                }
            }
            return cell
            
        case .UNKNOWN:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let data = audioReelsData?.data, indexPath.row < data.count else {
            return .zero
        }
        switch data[indexPath.row].getDesignShorts() {
        case .EXPLORE_SHORTS:
            return ExploreShortsCell.size
        case .RECOMANDED_SHORTS,.NEW_MUSIC:
            return SeeAllWithThreeImgCell.size
        case .UNKNOWN:
            return .zero
        }
    }
    
    private func didTapShortContentsCell(item: [ReelsContent], indexPath: IndexPath) {
        self.gotoShortsPlayerVC(data: item, indexPath: indexPath)
        self.navStackViewTextColorChange(isBool: true)
        self.crossBtn.isHidden = false
        self.navBtnStackView.spacing = 5
        self.shortsPlayCatBtnSelected(button: [self.forYouBtn, self.exploreBtn, self.followingBtn])
    }
}
