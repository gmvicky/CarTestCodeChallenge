//
//  ButtonLeftEdgeTextRightEdgeImage.swift.swift
//  xApp
//
//  Created by WT-iOS on 20/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit

class ButtonLeftEdgeTextRightEdgeImage: UIButton {
    
    @IBInspectable var imageOffset: CGFloat = 0
    @IBInspectable var textOffset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = .left
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = contentRect.size.width - imageOffset
        return imageFrame
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleFrame = super.titleRect(forContentRect: contentRect)
        titleFrame.origin.x = textOffset
        return titleFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.textAlignment = .left
    }
}
