//
//  FloatingPlaceholderTextfield.swift
//  SpesheSDKTestConsumer
//
//  Created by WT-iOS on 17/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import Combine

open class FloatingPlaceholderTextfieldView: UIView, ViewCoderLoadable {
    
    @IBOutlet public weak var constraintFloatingMode: NSLayoutConstraint!
    @IBOutlet public weak var constraintPlaceholderMode: NSLayoutConstraint!
    @IBOutlet public weak var textfield: UITextField!
    @IBOutlet public weak var titleLabel: UILabel!
    private let cancelBag = CancellableBag()
    
    lazy var textFieldDidEndEditingClosure: ((UITextField) -> ()) = {
        return { [weak self] textField in
            if textField.text?.isEmpty ?? true {
                self?.placeHolderMode()
            }
        }
    }()
    
    lazy var textFieldDidBeginEditingClosure: ((UITextField) -> ()) = {
        return { [weak self] _ in
            self?.floatingMode()
        }
    }()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
    }
    
    public func setText(_ text: String?) {
        textfield.text = text
        if text?.isEmpty ?? true {
            placeHolderMode()
        } else {
            floatingMode()
        }
    }
    
    public func placeHolderMode() {
        UIView.animate(withDuration: 0.3) {
            self.constraintFloatingMode.priority = .defaultLow
            self.constraintPlaceholderMode.priority = .defaultHigh
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    public func floatingMode() {
        
        UIView.animate(withDuration: 0.3) {
            self.constraintPlaceholderMode.priority = .defaultLow
            self.constraintFloatingMode.priority = .defaultHigh
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    public func observeFloating() {
        NotificationCenter.default
              .publisher(for: UITextField.textDidBeginEditingNotification, object: textfield)
              .sink(receiveValue: { [weak self] notif in
                if notif.object as? UITextField == self?.textfield {
                    self?.floatingMode()
                }
                  
              })
              .add(to: cancelBag)
          
          NotificationCenter.default
              .publisher(for: UITextField.textDidEndEditingNotification, object: textfield)
              .sink(receiveValue: { [weak self] in
                if let aTxtfield = ($0.object as? UITextField),
                    aTxtfield == self?.textfield,
                    aTxtfield.text?.isEmpty ?? true {
                      self?.placeHolderMode()
                  }
              })
              .add(to: cancelBag)
    }
}
