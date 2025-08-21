//
//  MenuCell.swift
//  Shadhin-BL
//
//  Created by Joy on 26/9/22.
//

import UIKit

class MenuCell: UITableViewCell {

    //MARK: create nib for access this cell
    static var identifier : String{
        return String(describing: self)
    }
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: Bundle.shadhinShorts)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(with model : MoreMenuModel){
        self.titleLabel.text = model.title
        self.iconIV.image = model.icon.uiImage
    }
}
