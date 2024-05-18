//
//  UITextField + Extension.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 13.01.2024.
//

import UIKit

class CustomTextFieldForm: UITextField {
    convenience init(cornerRadius: CGFloat = 5, placeholderText: String = "", keyboardType: UIKeyboardType, isPassword: Bool = false) {
        self.init()
        
        font = .mainFont20()
        borderStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = placeholderText
        isSecureTextEntry = isPassword
        autocapitalizationType = UITextAutocapitalizationType.none
        self.keyboardType = keyboardType
        
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
