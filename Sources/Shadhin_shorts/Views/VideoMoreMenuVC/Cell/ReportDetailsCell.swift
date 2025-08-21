//
//  ReportDetailsCell.swift
//  Shadhin_shorts
//
//  Created by Shadhin Music on 8/5/25.
//

import UIKit

class ReportDetailsCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var reportImageView: UIImageView!
    @IBOutlet weak var linkLabel: LinkLabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var reportHeader: UILabel!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var reportDescripLabel: UILabel!
    
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCellUI()
    }
    
    private func setupCellUI() {
        
        self.headerTitle.font = UIFont.circularStd(.bold, size: 22)
        self.reportHeader.font = UIFont.circularStd(.bold, size: 18)
        self.reportTitle.font = UIFont.inter(.medium, size: 16)
        self.reportDescripLabel.font = UIFont.inter(.regular, size: 14)
        
        self.linkLabel.setText(self.linkLabel.text ?? "", linkText: "Terms and conditions", font: UIFont.inter(.regular, size: 14)) {
            print("Terms and Conditions tapped")
            if let url = URL(string: "https://shadhin.co/terms_and_conditions_global_free.html") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func dataBind(data: VideoMoreMenuItems) {
        self.reportTitle.text = data.title
        self.reportDescripLabel.text = data.reportDetails
    }
}
