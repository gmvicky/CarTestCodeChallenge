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
    private let cancelBag = CancellableBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupObservers()
    }
    
    @IBAction func toggleAction(_ sender: Any) {
        let flag = textfield.isSecureTextEntry
        if flag {
            textfield.isSecureTextEntry = false
            toggleButtonVisibility
                .setImage(R.image.passwordShow(), for: .normal)
        } else {
            textfield.isSecureTextEntry = true
            toggleButtonVisibility
            .setImage(R.image.passwordHide(), for: .normal)
        }
    }
    
    private func setupObservers() {
        
        toggleButtonVisibility
            .setImage(textfield.isSecureTextEntry ? R.image.passwordHide() : R.image.passwordShow(), for: .normal)
        
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: textfield)
            .sink(receiveValue: { [weak self] _ in
                self?.floatingMode()
            })
            .add(to: cancelBag)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidEndEditingNotification, object: textfield)
            .sink(receiveValue: { [weak self] in
                if ($0.object as? UITextField)?.text?.isEmpty ?? true {
                    self?.placeHolderMode()
                }
            })
            .add(to: cancelBag)
    }
}
