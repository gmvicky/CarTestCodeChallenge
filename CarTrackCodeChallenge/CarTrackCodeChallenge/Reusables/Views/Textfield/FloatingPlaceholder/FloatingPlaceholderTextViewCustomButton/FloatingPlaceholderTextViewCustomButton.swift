//
//  FloatingPlaceholderTextViewCustomButton.swift
//  Speshe
//
//  Created by WT-iOS on 25/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class FloatingPlaceholderTextViewCustomButton: FloatingPlaceholderTextViewCustom {
    
    @IBOutlet weak var customButton: UIButton!
    
    @IBAction func togglePasswordVisibility(_ sender: Any) {
        
        let flag = textfield.isSecureTextEntry
        if flag {
            textfield.isSecureTextEntry = false
            customButton
                .setImage(R.image.passwordShow(), for: .normal)
        } else {
            textfield.isSecureTextEntry = true
            customButton
            .setImage(R.image.passwordHide(), for: .normal)
        }
    }
    
}
