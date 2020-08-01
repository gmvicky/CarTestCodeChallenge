//
//  ResponderViewHandler.swift
//  xApp
//
//  Created by WT-iOS on 12/12/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import NSObject_Rx

protocol ResponderSourceProtocol: class {
    var responders: [(UIResponder, characterSetLimiter: [CharacterSet]?)]? { get }
    
}

extension ResponderSourceProtocol {
    var responders: [(UIResponder, characterSetLimiter: [CharacterSet]?)]? { return nil }
    
}
protocol ResponderViewHandlerTextFieldDelegate: class {
    
}

protocol ResponderViewHandlerTextViewDelegate: class {
    
}

class ResponderViewHandler: NSObject {
    
    weak var textFieldDelegate: ResponderViewHandlerTextFieldDelegate?
    weak var textViewDelegate: ResponderViewHandlerTextViewDelegate?
    private var responders = [ResponderWrapper]()
    
    var currentResponders: [ResponderWrapper] { return responders }
    
    init(textFieldDelegate: ResponderViewHandlerTextFieldDelegate? = nil,
         textViewDelegate: ResponderViewHandlerTextViewDelegate? = nil) {
        self.textFieldDelegate = textFieldDelegate
        self.textViewDelegate = textViewDelegate
        super.init()
    }
    
    deinit { print("\(String(describing: self)) deinitialized") }
    
    func addResponders(_ respondersToAdd:[ResponderWrapper]) {
        respondersToAdd.forEach { aResponder in
            if !responders.contains(where: { $0.responder == aResponder.responder }) {
                responders.append(aResponder)
                checkProperties(responder: aResponder)
            }
        }
        checkResponders()
    }
    
    private func checkProperties(responder: ResponderWrapper) {
        if let textInput = responder.responder as? UITextInputTraits {
            if let limiters = responder.characterSetLimiter, limiters.count == 1, limiters.contains(.decimalDigits) {
                switch textInput {
                case let field as UITextField:
                    field.keyboardType = .numberPad
                case let field as UITextView:
                    field.keyboardType = .numberPad
                default: break
                }
            }
            
            if let textField = responder.responder as? UITextField {
                textField.delegate = self
            }
        }
        
        if responder.shouldCheckWhenValid {
            responder.isValidCurrentRelay
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.activateNextResponder(currentResponderView: responder.responder)
            })
            .disposed(by: rx.disposeBag)
        }
    }
    
    private func checkResponders() {
        responders.removeAll(where: { $0.responder == nil })
        
        for (index, item) in responders.enumerated() {
            switch (index, item.responder) {
            case (responders.count - 1, let textInput as (UITextInputTraits)):
                switch textInput {
                case let field as UITextField:
                    field.returnKeyType = .done
                case let field as UITextView:
                    field.returnKeyType = .done
                default: break
                }
            case (let index, let textInput as (UITextInputTraits)) where index < responders.count - 1:
                switch textInput {
                case let field as UITextField:
                    field.returnKeyType = .next
                case let field as UITextView:
                    field.returnKeyType = .next
                default: break
                }
            default:
                break
            }
        }
    }
    
    @discardableResult
    private func activateNextResponder(currentResponderView: UIResponder? = nil) -> Bool {
        var aResponder = currentResponderView
        if aResponder == nil {
            aResponder =  UIResponder.currentFirst()
        }
        
        guard let currentResponder = aResponder else { return true }
        
        let currentIndex = responders.firstIndex(where: { $0.responder == currentResponder })
        if let aIndex = currentIndex {
            if aIndex < responders.count - 1 {
                if responders[aIndex + 1].responder?.canBecomeFirstResponder ?? false {
                    responders[aIndex + 1].responder?.becomeFirstResponder()
                    return false
                } else {
                    currentResponder.resignFirstResponder()
                    if let button = responders[aIndex + 1].responder as? UIButton {
                        button.sendActions(for: .touchUpInside)
                    }
                }
            } else {
                currentResponder.resignFirstResponder()
            }
        }
        return true
    }
    
    private lazy var isValidClosure: ((Bool, UIResponder?) -> ()) = {
        return { [weak self] (flag, responder) in
            guard flag else { return }
            self?.activateNextResponder(currentResponderView: responder)
        }
    }()
}


extension ResponderViewHandler: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return activateNextResponder(currentResponderView: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let wrapper = responders.first(where: { $0.responder == textField }) as? TextfieldResponderWrapper  else { return true }
        
        if let limiters = wrapper.characterSetLimiter {
            if limiters.contains(where: { $0.isSuperset(of: CharacterSet(charactersIn: string))}) == false {
                return false
            }
        }
        
        if let maxCount = wrapper.maxCount,
            let textString = textField.text {
            let currentString = textString as NSString
            let newString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length > maxCount { return false }
        }
        
        if let shouldChangeClosure = wrapper.textFieldShouldChangeCharactersInClosure {
            return shouldChangeClosure(textField, range, string)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (responders.first(where: { $0.responder == textField }) as? TextfieldResponderWrapper)?.textFieldDidBeginEditingClosure?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (responders.first(where: { $0.responder == textField }) as? TextfieldResponderWrapper)?.textFieldDidEndEditingClosure?(textField)
    }
    
    
}

extension ResponderViewHandler: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            activateNextResponder(currentResponderView: textView)
            return false
        }
        return true
  }
}
