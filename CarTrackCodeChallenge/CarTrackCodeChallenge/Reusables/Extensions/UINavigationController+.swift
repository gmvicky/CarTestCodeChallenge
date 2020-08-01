//
//  UINavigationController+.swift
//  Speshe
//
//  Created by WT-iOS on 5/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func setTextColor(_ color: UIColor) {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
    
    func setLightText() {
        setTextColor(.white)
    }
    
    func setupPreferredNavigationAppearance() {
        
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance = UINavigationBarAppearance.transparentAppearance
            navigationBar.scrollEdgeAppearance = UINavigationBarAppearance.transparentAppearance
        } else {
            setLightText()
            transparentBar()
        }
    }
    
    func transparentBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
    }
}
