//
//  RadialGradientNavigationBar.swift
//  Speshe
//
//  Created by WT-iOS on 30/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit


class RadialGradientNavigationBar: UINavigationBar {
    
    
    private let gradientLayer = RadialGradientLayer()

    @IBInspectable var colors: [UIColor] {
        get {
            return gradientLayer.colors
        }
        set {
            gradientLayer.colors = newValue
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = bounds
    }
}
