//
//  ResponderWrapper.swift
//  SpesheSDKTestConsumer
//
//  Created by WT-iOS on 17/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import RxCocoa
import Action

class ResponderWrapper {
    
    weak var responder: UIResponder?
    var characterSetLimiter: [CharacterSet]?
    var maxCount: Int? = nil
    let shouldCheckWhenValid: Bool
    var isValidCurrentRelay = BehaviorRelay<Bool>(value: false)
    var tag: Int
    var onNextResponder: Action<Int, Void>?
    var preActivateResponder = false
    
    init(responder: UIResponder?,
         tag: Int = 0,
         characterSetLimiter: [CharacterSet]? = nil,
         maxCount: Int? = nil,
         shouldCheckWhenValid: Bool = true,
         onNextResponder: Action<Int, Void>? = nil ) {
        self.tag = tag
        self.responder = responder
        self.characterSetLimiter = characterSetLimiter
        self.maxCount = maxCount
        self.shouldCheckWhenValid = shouldCheckWhenValid
        self.onNextResponder = onNextResponder
    }
    
    func customAction() { }
    
    
}

class TextfieldResponderWrapper: ResponderWrapper {
    
        typealias textFieldShouldChangeCharactersInClosure = ((UITextField, NSRange, String) -> Bool)?
        
        var textFieldShouldChangeCharactersInClosure: textFieldShouldChangeCharactersInClosure
        var textFieldDidEndEditingClosure: ((UITextField) -> ())?
        var textFieldDidBeginEditingClosure: ((UITextField) -> ())?
        var textFieldEditingChanged: ((UITextField) -> ())?
    
        init(responder: UIResponder?,
             tag: Int,
             characterSetLimiter: [CharacterSet]? = nil,
             maxCount: Int? = nil,
             shouldCheckWhenValid: Bool = true,
             textFieldShouldChangeCharactersInClosure: textFieldShouldChangeCharactersInClosure = nil,
             textFieldDidBeginEditingClosure: ((UITextField) -> ())? = nil,
             textFieldDidEndEditingClosure: ((UITextField) -> ())? = nil) {
            self.textFieldShouldChangeCharactersInClosure = textFieldShouldChangeCharactersInClosure
            self.textFieldDidEndEditingClosure = textFieldDidEndEditingClosure
            self.textFieldDidBeginEditingClosure = textFieldDidBeginEditingClosure
            super.init(responder: responder, tag: tag, characterSetLimiter: characterSetLimiter, maxCount: maxCount, shouldCheckWhenValid: shouldCheckWhenValid)
        }
}
