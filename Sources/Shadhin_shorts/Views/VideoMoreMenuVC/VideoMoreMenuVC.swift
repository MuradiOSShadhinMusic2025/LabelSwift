//
//  VideoMoreMenuVC.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 7/5/25.
//

import UIKit

class VideoMoreMenuVC: UIViewController, NIBVCProtocol {

    // MARK: --- Outlets ---
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var videoFirstView: VideoMoreFirstView!
    @IBOutlet weak var videoSeondView: VideoMoreSecondView!
    @IBOutlet weak var videoThirdView: VideoMoreThirdView!
    @IBOutlet weak var videoMoreFirstTrailing: NSLayoutConstraint!
    @IBOutlet weak var videoMoreSecondTrailing: NSLayoutConstraint!
    @IBOutlet weak var videoMoreThirdTrailing: NSLayoutConstraint!
        
    // MARK: ---- Properties ----
    static var shared = VideoMoreMenuVC()
    var didInterested : ((String) -> Void)?
    var didTapSumbit : ((Bool) -> Void)?
    
    
    // MARK: ---- Life/Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seutpUI()
    }
    
    // MARK: ---- Actions  ----
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}


// MARK: ---- Private Methods ----

extension VideoMoreMenuVC {
    
    private func seutpUI() {
        self.bgView.layer.cornerRadius = 24
        self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bgView.clipsToBounds = true
        self.bgViewHeightLayout.constant = 290
        self.videoMoreFirstTrailing.constant = 0
        self.videoMoreSecondTrailing.constant = -DEVICE_WIDTH
        self.videoMoreThirdTrailing.constant = -DEVICE_WIDTH
        
        // Clouser Declare
        self.videoFirstView.didTappedIndex = { [self] index in
            switch index {
            case 0:
                                
                ShadhinShortsApi.shared.surveySubmitData(id: ShadhinShort.shared.reelsContent?.id ?? 0, contentType: ShadhinShort.shared.reelsContent?.contentType?.rawValue ?? "", interestStatus: "Interested", reportCategory: ShadhinShort.shared.videoMenuFirstItems[index].subTitle ?? "") { _, _ in
                    self.didInterested?(ShadhinShort.shared.videoMenuFirstItems[index].subTitle ?? "")
                    SwiftEntryKit.dismiss()
                }
            
            case 1:
                self.didInterested?(ShadhinShort.shared.videoMenuFirstItems[index].subTitle ?? "")

                ShadhinShortsApi.shared.surveySubmitData(id: ShadhinShort.shared.reelsContent?.id ?? 0, contentType: ShadhinShort.shared.reelsContent?.contentType?.rawValue ?? "", interestStatus: "Not Interested", reportCategory: ShadhinShort.shared.videoMenuFirstItems[index].subTitle ?? "") { _, _ in
                    self.didInterested?(ShadhinShort.shared.videoMenuFirstItems[index].subTitle ?? "")
                    SwiftEntryKit.dismiss()
                }
            
            case 2:
                self.secondViewLayoutUpdate(isPlus: true)
            
            default:
                break
            }
        }
        
        self.videoSeondView.didTappedIndex = { index in
            self.videoThirdView.videoMenuItems = [ShadhinShort.shared.videoMenuSecondItems[index]]
            self.thirdViewLayoutUpdate()
        }
        
        self.videoSeondView.didTappedBackBtn = {
            self.firstViewLayoutUpdate()
        }
        
        self.videoThirdView.didTappedBackBtn = {
            self.secondViewLayoutUpdate(isPlus: false)
        }
        
        self.videoThirdView.didTappedCancelBtn = {
            SwiftEntryKit.dismiss()
        }
        
        self.videoThirdView.didTappedSubmitBtn = { item in
            ShadhinShortsApi.shared.surveySubmitData(id: ShadhinShort.shared.reelsContent?.id ?? 0, contentType: ShadhinShort.shared.reelsContent?.contentType?.rawValue ?? "", interestStatus: "Not Interested", reportCategory: item.title) { data, error in
                SwiftEntryKit.dismiss()
                if let _ = data {
                    ShadhinShort.shared.isErrorText = nil
                    self.didTapSumbit?(true)
                }
                
                if let error = error {
                    ShadhinShort.shared.isErrorText = error.localizedDescription
                    self.didTapSumbit?(false)
                }
            }
        }
    }
    
    private func firstViewLayoutUpdate() {
        UIView.animate(withDuration: 0.3) {
            self.videoMoreFirstTrailing.constant = 0
            self.videoMoreSecondTrailing.constant = -DEVICE_WIDTH
            self.videoMoreThirdTrailing.constant = -DEVICE_WIDTH
            self.bgViewHeightLayout.constant = 290
            self.view.layoutIfNeeded()
            self.videoFirstView.layoutIfNeeded()
        }
    }
    
    private func secondViewLayoutUpdate(isPlus: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bgViewHeightLayout.constant = DEVICE_HIEGHT <= 625 ? 615 : 625
            self.videoMoreFirstTrailing.constant = DEVICE_WIDTH
            self.videoMoreSecondTrailing.constant = 0
            self.videoMoreThirdTrailing.constant = -DEVICE_WIDTH
            self.videoSeondView.collectionView.isScrollEnabled = DEVICE_HIEGHT <= 625 ? true : false
            self.view.layoutIfNeeded()
            self.videoSeondView.collectionView.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.animateCollectionCells(width: isPlus ? 300 : -300)
        }
    }
    
    private func thirdViewLayoutUpdate() {
        UIView.animate(withDuration: 0.3) {
            self.bgViewHeightLayout.constant = 570
            self.videoMoreFirstTrailing.constant = DEVICE_WIDTH
            self.videoMoreSecondTrailing.constant = DEVICE_WIDTH
            self.videoMoreThirdTrailing.constant = 0
            self.view.layoutIfNeeded()
            self.videoThirdView.layoutIfNeeded()
            self.videoThirdView.collectionView.layoutIfNeeded()
        }
    }
    
    private func animateCollectionCells(width: CGFloat) {
        let cells = self.videoSeondView.collectionView.visibleCells
        let collectionViewWidth = width
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: CGFloat(collectionViewWidth), y: 0)
            cell.alpha = 0
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0.02 * Double(index),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.2,
                options: [],
                animations: {
                    cell.transform = .identity
                    cell.alpha = 1
                },
                completion: nil
            )
        }
    }
    
    public static func shows(safeArea: CGFloat = 0,
                             didInterested: @escaping (String) -> Void,
                             didTapSumbit: @escaping (Bool) -> Void) {
        let vc = VideoMoreMenuVC.instantiateNib()
        vc.didInterested = didInterested
        vc.didTapSumbit = didTapSumbit
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
    }
}
