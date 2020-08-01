//
//  FloatingPasswordPlaceholderTextView.swift
//  Speshe
//
//  Created by WT-iOS on 24/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class FloatingPasswordPlaceholderTextView: FloatingPlaceholderTextfieldView {
    
    @IBOutlet weak var toggleButtonVisibility: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        toggleButtonVisibility
        .setImage(textfield.isSecureTextEntry ? R.image.passwordHide() : R.image.passwordShow(), for: .normal)
    }
    
    @IBAction func toggleAction(_ sender: Any) {
        let flag = textfield.isSecureTextEntry
        if flag {
            textfield.isSecureTextEntry = false
            toggleButtonVisibility.setImage(R.image.passwordShow(), for: .normal)
        } else {
            textfield.isSecureTextEntry = true
            toggleButtonVisibility.setImage(R.image.passwordHide(), for: .normal)
        }
    }
}
