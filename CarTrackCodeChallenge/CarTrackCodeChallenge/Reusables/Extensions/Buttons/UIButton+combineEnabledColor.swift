//
//  UIButton+combineEnabledColor.swift
//  SpesheSDKTestConsumer
//
//  Created by WT-iOS on 18/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import Combine

extension UIButton {
    
    func isEnabledCombine(flag: Bool) {
        backgroundColor = flag ? .systemYellow : .systemGray
        isEnabled = flag
    }
}
