//
//  UINavigationApperance+.swift
//  Speshe
//
//  Created by WT-iOS on 4/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

extension UINavigationBarAppearance {
    
    static var blackBarAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance.init()
        
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
        .font: UIFont.boldSystemFont(ofSize: 30)]
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .black
        
        let gradient = RadialGradientLayer()
        gradient.colors = UIColor.gradientColors
        if let image = UIImage.getImageFrom(gradientLayer: gradient) {
//            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            appearance.backgroundImage = image
        }
        
        return appearance
    }()
    
    static var transparentAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance.init()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
        .font: UIFont.boldSystemFont(ofSize: 30)]
        appearance.shadowImage = UIImage()
        return appearance
    }()
    
    static var transparentAppearanceLargeTitle: UINavigationBarAppearance = {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
        .font: UIFont.boldSystemFont(ofSize: 30)]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundImage = UIImage() //R.image.background1()
        return navBarAppearance
    }()
    
    static var semitransparentAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance.init()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 30)]
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        return appearance
    }()
}
