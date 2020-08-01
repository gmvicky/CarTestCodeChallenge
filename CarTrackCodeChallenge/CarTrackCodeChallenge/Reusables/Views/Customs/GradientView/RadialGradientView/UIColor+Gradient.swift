//
//  UIColor+Gradient.swift
//  Speshe Business
//
//  Created by WT-iOS on 15/3/20.
//  Copyright © 2020 roamsoft. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var gradientColors: [UIColor] = {
       return [UIColor.init(red: 254/255, green: 198/255, blue: 0/255, alpha: 1.0), UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)]
    }()
    
    static func rgb(_ rgb: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
      return UIColor(red: rgb / 255.0, green: rgb / 255.0, blue: rgb / 255.0, alpha: alpha)
    }
}
