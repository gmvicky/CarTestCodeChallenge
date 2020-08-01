//
//  ButtonTintBackgroundHighlight.swift
//  Speshe
//
//  Created by WT-iOS on 31/1/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class ButtonTintBackgroundHighlight: UIButton {
    
    @IBInspectable var defaultBackgroundColor: UIColor = .white
    @IBInspectable var highlightedBackgroundColor: UIColor = .lightGray
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedBackgroundColor
            } else {
                backgroundColor = defaultBackgroundColor
            }
            
        }
    }
}
