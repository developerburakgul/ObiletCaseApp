//
//  UIButton+Extension.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 16.08.2024.
//

import Foundation
import UIKit

extension UIButton {
    
    static func createCategoryButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.backgroundColor = .systemGray6
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        
        button.titleLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
        button.titleLabel?.setContentHuggingPriority(.required, for: .vertical)
        
        return button
    }
}
