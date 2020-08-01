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


extension RadialGradientButton {
    struct IntSize: Hashable {
        let width: Int
        let height: Int
        let cornerRadius: CGFloat
    }
    
    struct GradientBackgroundImage {
           static var collection =  [IntSize: UIImage]()
           
           static func imageForSize(_ size: IntSize) -> UIImage? {
               var image = collection[size]
               if image == nil {
                   let gradient = RadialGradientLayer()
                   gradient.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                   gradient.colors = UIColor.gradientColors
                    gradient.cornerRadius = size.cornerRadius
                   if let newImage = UIImage.getImageFrom(gradientLayer: gradient)?.withRenderingMode(.alwaysOriginal) {
                       image = newImage
                       collection[size] = newImage
                   }
                   
               }
               return image
           }
       }
}

extension Reactive where Base: UIButton {
    
    var isEnabledColor: Binder<Bool> {
        return Binder(base) { button, flag in
            DispatchQueue.main.async {
                
//                button.backgroundColor = flag ? R.color.marigold() : R.color.placeHolderText()
//                button .setTitleColor(flag ? .white : .lightGray, for: .normal)
                if flag {
                    button.setGradient()
                    
                } else {
                    button.backgroundColor = R.color.placeHolderText()
                    button.layer.shadowColor = UIColor.clear.cgColor
                    button.setBackgroundImage(nil, for: .normal)
                }
            }
        }
    }
}
