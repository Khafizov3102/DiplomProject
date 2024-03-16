//
//  UITextField + Extension.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 13.01.2024.
//

import UIKit

class AuthTextFieldForm: UITextField {
    convenience init(cornerRadius: CGFloat = 5, placeholderText: String = "",  isActive: Bool) {
        self.init()
        
        font = .mainFont20()
        borderStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        
        var bottomView = UIView()
        bottomView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .lightGray
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
