//
//  KeyboardVisibileAdjusterProtocol.swift
//  xApp
//
//  Created by WT-iOS on 6/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit

enum KeyboardVisibleAdjustType {
    case scrollView
    case constraint
}

protocol KeyboardVisibleAdjusterProtocol {
    
    var adjustType: KeyboardVisibleAdjustType { get }
    
    func updateComponent(_ keyboardHeight: CGFloat, keyboardFocusRect: CGRect?)
}

struct KeyboardVisibileAdjustScrollView: KeyboardVisibleAdjusterProtocol {
    
    var adjustType: KeyboardVisibleAdjustType { return .scrollView }
    
    private let scrollView: UIScrollView
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func updateComponent(_ keyboardHeight: CGFloat, keyboardFocusRect: CGRect?) {
        scrollView.updateBottomInset(keyboardHeight, keyboardFocusRect: keyboardFocusRect)
        
    }
}

struct KeyboardVisibileAdjustConstraint: KeyboardVisibleAdjusterProtocol {
    
    var adjustType: KeyboardVisibleAdjustType { return .constraint }
    
    private let defaultValue: CGFloat
    private let customMultiplier: CGFloat
    private weak var bottomConstraint: NSLayoutConstraint?
    private weak var superView: UIView?
    
    init(bottomConstraint: NSLayoutConstraint,
         superView: UIView?,
         customMultiplier: CGFloat = 1) {
        self.bottomConstraint = bottomConstraint
        self.defaultValue = bottomConstraint.constant
        self.customMultiplier = customMultiplier
        self.superView = superView
    }
    
    func updateComponent(_ keyboardHeight: CGFloat, keyboardFocusRect: CGRect?) {
        let modifiedValue = keyboardHeight == .zero ? defaultValue : keyboardHeight * customMultiplier
        UIView.animate(withDuration: 0.15, animations: {
            self.bottomConstraint?.constant = modifiedValue
            self.superView?.setNeedsLayout()
            self.superView?.layoutIfNeeded()
        })
    }
}

struct KeyboardVisibileAdjustCenterConstraint: KeyboardVisibleAdjusterProtocol {
    
    var adjustType: KeyboardVisibleAdjustType { return .constraint }
    
    private let defaultValue: CGFloat
    private let customMultiplier: CGFloat
    private weak var centerConstraint: NSLayoutConstraint?
    private weak var superView: UIView?
    
    init(centerConstraint: NSLayoutConstraint,
         superView: UIView?,
         customMultiplier: CGFloat = 1) {
        self.centerConstraint = centerConstraint
        self.defaultValue = centerConstraint.constant
        self.customMultiplier = customMultiplier
        self.superView = superView
    }
    
    func updateComponent(_ keyboardHeight: CGFloat, keyboardFocusRect: CGRect?) {
        let modifiedValue = keyboardHeight == .zero ? defaultValue : customMultiplier
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.centerConstraint?.constant = modifiedValue
                self.superView?.setNeedsLayout()
                self.superView?.layoutIfNeeded()
            })
        }
    }
}
