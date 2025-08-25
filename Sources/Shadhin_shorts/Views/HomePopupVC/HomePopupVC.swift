//
//  HomePopupVC.swift
//  Shadhin_shorts
//
//  Created by MD Murad Hossain on 24/3/25.
//

import UIKit
import Lottie
import SwiftEntryKit
import Alamofire
import Kingfisher


public class HomePopupVC: UIViewController, NIBVCProtocol {

    // MARK: - Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topbarLineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnExplore: UIButton!
    @IBOutlet weak var btnNotNow: UIButton!
    @IBOutlet weak var bgViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var headerShortsAnimView: LottieAnimationView!
    
    // MARK: - Properties

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupUI()
    }

    
    // MARK: - Actions
    
    @IBAction func didTapExploreAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let vc = HomeExploreVC(nibName: "HomeExploreVC", bundle: Bundle.module)
                let navController = UINavigationController(rootViewController: vc)
                navController.isNavigationBarHidden = true
                navController.modalPresentationStyle = .fullScreen
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func didTapNotNowAction(_ sender: UIButton) {
        
    }
    
    @IBAction func topToDismissAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}


// MARK: - Private Methods

extension HomePopupVC {
    
    private func setupUI() {
//        self.headerShortsAnimView.animation = LottieAnimation.named("Reels_header")
//        self.headerShortsAnimView.loopMode = .loop
//        self.headerShortsAnimView.play()
        
        if let path = Bundle.module.path(forResource: "Reels_header", ofType: "json") {
            print("✅ Found animation at \(path)")
        } else {
            print("❌ Animation file not found in Bundle.module")
        }

//        if let path = Bundle.module.path(forResource: "Reels_header", ofType: "json") {
//            headerShortsAnimView.animation = LottieAnimation.filepath(path)
//            headerShortsAnimView.loopMode = .loop
//            headerShortsAnimView.play()
//        } else {
//            print("❌ Reels_header.json not found in bundle")
//        }


        self.btnExplore.layer.cornerRadius = self.btnExplore.bounds.height/2
        self.btnExplore.titleLabel?.font = DEVICE_HIEGHT > 990 ? UIFont.inter(.medium, size: 24) : UIFont.inter(.medium, size: 16)
        self.btnNotNow.titleLabel?.font = DEVICE_HIEGHT > 990 ? UIFont.inter(.medium, size: 24) : UIFont.inter(.medium, size: 16)
        self.btnNotNow.layer.cornerRadius = self.btnNotNow.bounds.height/2
        self.bgViewHeightLayout.constant = (617/852)*DEVICE_HIEGHT
        self.topbarLineView.layer.cornerRadius = self.topbarLineView.bounds.height/2
        self.bgView.layer.cornerRadius = 24
        self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bgView.clipsToBounds = true
        self.titleLabel.font = DEVICE_HIEGHT > 736 ? DEVICE_HIEGHT > 990 ? UIFont.circularStd(.book, size: 32) : UIFont.circularStd(.book, size: 28) : UIFont.circularStd(.book, size: 22)
    }
    
    public static func shows(_ safeArea: CGFloat = 0) {
//        let vc = HomePopupVC(nibName: "HomePopupVC", bundle: Bundle(for: HomePopupVC.self))
        let vc = HomePopupVC(nibName: "HomePopupVC", bundle: Bundle.module) // <--- Bundle.module is key

        var attributes = EKAttributes.bottomToast
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.5)))
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
