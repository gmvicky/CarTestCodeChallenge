//
//  UIButton+Gradient.swift
//  Speshe
//
//  Created by WT-iOS on 31/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setGradient() {
//        let size = RadialGradientButton.IntSize(width: Int(frame.width), height: Int(frame.height), cornerRadius: layer.cornerRadius)
//        let image = RadialGradientButton
//            .GradientBackgroundImage.imageForSize(size)
//        setBackgroundImage(image, for: .normal)
//        backgroundColor = .clear
//        imageView?.clipsToBounds = true
//        clipsToBounds = true
//        addShadow()
        backgroundColor = R.color.marigoldTwo() ?? .yellow
        setTitleColor(.black, for: .normal)
        
    }
}
