//
//  ReportSuccessVC.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 12/5/25.
//

import UIKit
import SwiftEntryKit

class ReportSuccessVC: UIViewController, NIBVCProtocol {
    
    // MARK: ---- Outlets ----
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupUI()
    }
    
    // MARK: ---- Private Methods ----

    @IBAction func doneButtonAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
        
    private func setupUI() {
        self.bgView.layer.cornerRadius = 24
        self.doneBtn.layer.cornerRadius = self.doneBtn.bounds.height/2
        self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bgView.clipsToBounds = true
        self.doneBtn.clipsToBounds = true
        self.titleLabel.font = UIFont.circularStd(.book, size: 28)
        self.subTitleLabel.font = UIFont.inter(.regular, size: 16)
        self.doneBtn.titleLabel?.font = UIFont.inter(.medium, size: 16)
        self.imageView.image = ShadhinShort.shared.reportSubmitImage
        
        if !(ShadhinShort.shared.isErrorText == nil) {
            self.titleLabel.text = "Opps!"
            self.subTitleLabel.text = ShadhinShort.shared.isErrorText
        }
        else {
            self.titleLabel.text = "Thanks for letting us know"
            self.subTitleLabel.text = "We will use your feedback to help our system monitor content that may not be right for you and others."
        }
    }
    
    public static func shows(safeArea: CGFloat = 0) {
        let vc = ReportSuccessVC.instantiateNib()
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
