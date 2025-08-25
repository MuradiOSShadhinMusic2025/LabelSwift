//
//  EmptyCell.swift
//  Shadhin_shorts
//
//  Created by Maruf on 8/4/25.
//

import Foundation
import UIKit

class EmptyCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle:Bundle.shadhinShorts)
    }
}
