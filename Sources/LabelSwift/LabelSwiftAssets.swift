//
//  ResourceProvider.swift
//  LabelSwift
//
//  Created by Shadhin Music on 21/8/25.
//

import UIKit

public class LabelSwiftAssets {
    public static let bundle = Bundle.module
    private init() {}
    
    public static let shadowBg: UIImage? = {
        UIImage(named: "shadowBg", in: bundle, compatibleWith: nil)
    }()
}
