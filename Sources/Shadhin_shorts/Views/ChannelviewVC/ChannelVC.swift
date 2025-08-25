//
//  ChannelVC.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 27/4/25.
//

import UIKit

class ChannelVC: UIViewController {

    // MARK: ---- Outlets ----
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerIndicator: UIActivityIndicatorView!
    @IBOutlet weak var footerIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var headerBgImgView: UIImageView!
    
    // MARK: ---- Properties ----
    var channelHeaderData: ChannelHeaderData? {
        didSet {
            if channelHeaderData == nil {
                self.headerIndicator.startAnimating()
            } else {
                self.headerIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    var reelsContents: [ReelsContent]? {
        didSet {
            if reelsContents == nil {
                self.footerIndicator.startAnimating()
            } else {
                self.footerIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    var viewModel = AudioReelsViewModel()
    var isLoadingMoreData = false
    var nextCursor: Int = 0
    var channelID: Int = 0
    var contentType: String = ""
    var hasMoreData: Bool = true
    var isHashTag: Bool = false
    var didTapShortsContent: ((Int, [ReelsContent]) -> Void)?
        
    // MARK: ---- Life cycle ----

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupCollectionView()
    }
    
    
    // MARK: ---- Actions ----
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: ---- Private Methods ----

extension ChannelVC {
    
    private func setupUI() {
        self.headerBgImgView.image = self.isHashTag ? UIImage(named: "hashtagBgImage") : UIImage(named: "channelBgImage")
        self.shareBtn.isHidden = !self.isHashTag
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = self.createLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.collectionView.register(ChannelviewCell.nib, forCellWithReuseIdentifier: ChannelviewCell.identifier)
        self.collectionView.register(SocialMediaCell.nib, forCellWithReuseIdentifier: SocialMediaCell.identifier)
        self.collectionView.register(CommonTwoRowCell.nib, forCellWithReuseIdentifier: CommonTwoRowCell.identifier)
        self.collectionView.register(LoadingFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
                
            case 0:
                let height: CGFloat = self.isHashTag ? 200 : 280
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(height))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case 1:
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(120),
                    heightDimension: .absolute(50)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(500),
                    heightDimension: .absolute(50)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(5)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16)
                return section

            case 2:
                
                let cellSize = CommonTwoRowCell.sizeTwoRowCelll
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(cellSize.width),
                    heightDimension: .absolute(cellSize.height)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(cellSize.height)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 2
                )
                group.interItemSpacing = .fixed(15)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
                section.interGroupSpacing = 16
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(40))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom)
                section.boundarySupplementaryItems = [footer]

                return section

            default:
                return nil
            }
        }
        return layout
    }
    
    fileprivate func didTapFollowButton(_ cell: ChannelviewCell) {
        
        cell.didTappedFollow = {
            ShadhinShort.shared.setupChannelFollowUnFollowing(id: self.channelHeaderData?.id ?? 0, contentType: "C")
        }
    }
    
    fileprivate func didTapShareButton(_ cell: ChannelviewCell) {
        cell.didTappedShare = {
            
            print("Share Button Click")
        }
    }
}


// MARK: ---- CollectionView Delegate Methods----

extension ChannelVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return self.channelHeaderData?.socialMediaLinks.count ?? 0
        case 2:
            return self.reelsContents?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelviewCell.identifier, for: indexPath) as! ChannelviewCell
            cell.isHashtag = self.isHashTag
            cell.dataBindCell(data: self.channelHeaderData)
            self.didTapFollowButton(cell)
            self.didTapShareButton(cell)
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialMediaCell.identifier, for: indexPath) as! SocialMediaCell
            cell.dataBindCell(data: self.channelHeaderData?.socialMediaLinks[indexPath.row])
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonTwoRowCell.identifier, for: indexPath) as! CommonTwoRowCell
            cell.dataBindCell(data: self.reelsContents?[indexPath.row], isHashTag: self.isHashTag, hashTag: self.channelHeaderData?.title ?? "")
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: LoadingFooterView.identifier,
                                                                     for: indexPath) as! LoadingFooterView

        if isLoadingMoreData && indexPath.section == 2 {
            footer.startAnimating()
        } else {
            footer.stopAnimating()
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        switch indexPath.section {
        case 0:
            break
            
        case 1:
            ShadhinShort.shared.openSocialMediaLink(name: "\(self.channelHeaderData?.socialMediaLinks[indexPath.row].socialMediaName ?? "")", fallbackURL: "\(self.channelHeaderData?.socialMediaLinks[indexPath.row].externalAccLink ?? "")")
        
        case 2:
            self.didTapShortsContent?(indexPath.row, (self.reelsContents)!)
        
        default:
            break
        }
    }
}

// MARK: -- DidScroll to More data loaded
extension ChannelVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingMoreData, hasMoreData else { return }
        let position = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight - 100) {
            self.loadMoreReelsContents()
        }
    }
    
    private func loadMoreReelsContents() {
        guard !isLoadingMoreData else { return }
        isLoadingMoreData = true
        
        self.collectionView.reloadSections(IndexSet(integer: 2))
        self.viewModel.api.getMusicContentDetailsData(contentId: channelID,
                                                      contentType: self.contentType,
                                                      nextCursor: nextCursor,
                                                      pageSize: 20) { [weak self] data, error in
            guard let self = self else { return }
            
            self.isLoadingMoreData = false
            if let data = data?.data {
                if data.contents.isEmpty {
                    self.hasMoreData = false
                } else {
                    if self.reelsContents == nil {
                        self.reelsContents = data.contents
                    } else {
                        self.reelsContents?.append(contentsOf: data.contents)
                    }
                    self.nextCursor = data.nextCursor
                }
            }
            
            if let error = error {
                print("Error loading more reels: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 2))
            }
        }
    }
}
