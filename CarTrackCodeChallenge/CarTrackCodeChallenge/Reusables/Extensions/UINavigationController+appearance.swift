//
//  UINavigationController+appearance.swift
//  Speshe
//
//  Created by WT-iOS on 3/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func bothAppearancGradient() {
        smallitleGradient()
        largeTitleGradient()
        
    }
    
    func smallitleGradient() {
        if navigationBar.standardAppearance.backgroundImage == nil {
            
            let gradient = RadialGradientLayer()
            gradient.bounds = navigationBar.bounds
            gradient.colors = UIColor.gradientColors
            if let image = UIImage.getImageFrom(gradientLayer: gradient) {
                navigationBar.standardAppearance.backgroundImage = image
            }
        }
         
    }
    
    func largeTitleGradient() {
//        if navigationBar.scrollEdgeAppearance?.backgroundImage == nil {
             
             let gradient = RadialGradientLayer()
             gradient.bounds = navigationBar.bounds
             gradient.colors = UIColor.gradientColors
             if let image = UIImage.getImageFrom(gradientLayer: gradient) {
                 navigationBar.scrollEdgeAppearance?.backgroundImage = image
             }
//         }
         
    }
}
