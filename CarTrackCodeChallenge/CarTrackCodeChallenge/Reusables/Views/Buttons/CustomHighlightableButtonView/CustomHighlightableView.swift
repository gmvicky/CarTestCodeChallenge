//
//  CustomHighlightableView.swift
//  Speshe
//
//  Created by WT-iOS on 3/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

@objc protocol CustomHighlightableViewProtocol {
    var customNormalColor: UIColor? { get set }
    var customHighlightedColor: UIColor? { get set }
    func customHighlightedStateChange(flag: Bool)
}


class CustomHighlightableView: UIView, CustomHighlightableViewProtocol {
    
    @IBInspectable
    var customNormalColor: UIColor? = nil {
        didSet {
            backgroundColor = customNormalColor
        }
    }
    @IBInspectable
    var customHighlightedColor: UIColor? = nil
    
    func customHighlightedStateChange(flag: Bool) {
        switch (flag, customNormalColor, customHighlightedColor) {
        case (true, _,.some(let color)):
            backgroundColor = color
        case (false, .some(let color), _):
            backgroundColor = color
        default:
            break
        }
    }
}

class CustomHighlightableImageView: UIImageView, CustomHighlightableViewProtocol {
    
    @IBInspectable
    var customNormalColor: UIColor? = nil {
        didSet {
            tintColor = customNormalColor
        }
    }
    @IBInspectable
    var customHighlightedColor: UIColor? = nil
    
    func customHighlightedStateChange(flag: Bool) {
        switch (flag, customNormalColor, customHighlightedColor) {
        case (true, _,.some(let color)):
            tintColor = color
        case (false, .some(let color), _):
            tintColor = color
        default:
            break
        }
    }
    
}

