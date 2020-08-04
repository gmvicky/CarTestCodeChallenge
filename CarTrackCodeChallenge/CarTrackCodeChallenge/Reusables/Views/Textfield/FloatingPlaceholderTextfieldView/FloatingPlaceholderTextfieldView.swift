//
//  FloatingPlaceholderTextfield.swift
//  SpesheSDKTestConsumer
//
//  Created by WT-iOS on 17/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

open class FloatingPlaceholderTextfieldView: UIView, ViewCoderLoadable {
    
    @IBOutlet public weak var constraintFloatingMode: NSLayoutConstraint!
    @IBOutlet public weak var constraintPlaceholderMode: NSLayoutConstraint!
    @IBOutlet public weak var textfield: UITextField!
    @IBOutlet public weak var titleLabel: UILabel!
    
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
        setupObservers()
    }
    
    func setText(_ text: String?) {
        textfield.text = text
        if text?.isEmpty ?? true {
            placeHolderMode()
        } else {
            floatingMode()
        }
    }
    
    func placeHolderMode() {
        UIView.animate(withDuration: 0.3) {
            self.constraintFloatingMode.priority = .defaultLow
            self.constraintPlaceholderMode.priority = .defaultHigh
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    func floatingMode() {
        
        UIView.animate(withDuration: 0.3) {
            self.constraintPlaceholderMode.priority = .defaultLow
            self.constraintFloatingMode.priority = .defaultHigh
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
     func setupObservers() {
           
       textfield.rx.controlEvent([.editingDidBegin])
           .mapTo(())
           .asObservable()
           .subscribe(onNext: activateState)
           .disposed(by: rx.disposeBag)
       
       textfield.rx.controlEvent([.editingDidEnd])
       .mapTo(())
       .asObservable()
       .subscribe(onNext: deactivateState)
       .disposed(by: rx.disposeBag)
   }
    
    func activateState() {
        floatingMode()
        titleLabel.textColor = .label
    }
    
    func deactivateState() {
        
        if textfield.text?.isEmpty ?? true {
            placeHolderMode()
        }
        titleLabel.textColor = .lightGray
    }
}
