//
//  UILabel + Extension.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 13.01.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String, labelFont: UIFont? = .mainFont20(), color: UIColor? = .mainGrey()) {
        self.init()
        
        self.text = text
        font = labelFont
        textAlignment = .left
        textColor = .mainDark()
    }
}
