//
//  UIButton+enabledColorBinder.swift
//  xApp
//
//  Created by WT-iOS on 22/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    var isEnabledColor: Binder<Bool> {
        return Binder(base) { button, flag in
            DispatchQueue.main.async {
                
                if flag {
                    button.backgroundColor = AppConstants.ThemeColor.mainColor
                } else {
                    button.backgroundColor = AppConstants.ThemeColor.secondaryColor
                }
            }
        }
    }
}
