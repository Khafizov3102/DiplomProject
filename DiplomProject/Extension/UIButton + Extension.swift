//
//  UIButton + Extension.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 13.01.2024.
//

import UIKit

extension UIButton {
    convenience init(
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        font: UIFont? = .mainFont20(),
        cornerRadius: CGFloat = 4
    ) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = .mainFont20()
        
        layer.cornerRadius = cornerRadius
    }
}
