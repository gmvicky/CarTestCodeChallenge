//
//  UITextfield+placeholderColor.swift
//  Speshe
//
//  Created by WT-iOS on 23/1/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setPlaceholderAttributes(_ color: UIColor, placeHolderText: String? = nil) {
        let placeHolderText = placeHolderText ?? placeholder ?? String()
        attributedPlaceholder = NSAttributedString(string: placeHolderText,
        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
