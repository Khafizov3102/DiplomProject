//
//  UILabel + Extension.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 13.01.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String, labelFont: UIFont? = .mainFont20(), color: UIColor? = .mainGrey(), textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        
        self.text = text
        font = labelFont
        self.textAlignment = textAlignment
        textColor = .mainDark()
        self.numberOfLines = numberOfLines
    }
}
