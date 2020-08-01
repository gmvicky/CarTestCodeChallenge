//
//  VisualEffectBackgroundButton.swift
//  xApp
//
//  Created by WT-iOS on 14/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import VisualEffectView

class VisualEffectBackgroundButtonView: UIView, ViewCoderLoadable {
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var blueView: VisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
        backgroundColor = .clear
        blueView.blurRadius = 3
    }
    
}
