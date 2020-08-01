//
//  CALayer+Color.swift
//  FrontRow
//
//  Created by WT-iOS on 21/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
    var shadowColorFromUIColor: UIColor {
        get {
            return UIColor(cgColor: self.shadowColor ?? UIColor.clear.cgColor)
        } set {
            self.shadowColor =  newValue.cgColor
        }
    }

}
