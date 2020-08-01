//
//  VerificationCodeInputView.swift
//  DinDinn
//
//  Created by DD_01 on 8/4/19.
//  Copyright © 2019 DinDinn. All rights reserved.
//

import Foundation
import UIKit

class VerificationCodeInputView: UIView {
    
    @IBOutlet weak var inputLabel: UILabel!
    private var secondaryValue: String?
    var isSecureTextEntry = true
    
    var getValue: String? {
        return secondaryValue
    }
    
    func setText(_ text: String?) {
        inputLabel.text = isSecureTextEntry ? "*" : text
        secondaryValue = text
    }
    
    func deleteText() {
        inputLabel.text = nil
        secondaryValue = nil
    }
    
    func reset() {
        secondaryValue = nil
        inputLabel.text = nil
    }
}
