//
//  UITableView+.swift
//  InstantMac
//
//  Created by Harold on 29/06/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit

extension UIScrollView {
  
  func updateBottomInset(_ bottomInset: CGFloat, keyboardFocusRect: CGRect? = nil, animated: Bool = true) {

    DispatchQueue.main.async {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.beginFromCurrentState, .curveEaseInOut],
                       animations: {
                        self.contentInset.bottom = bottomInset
                        self.verticalScrollIndicatorInsets.bottom = bottomInset

        }, completion: { _ in

            if var keyboardFocusRect = keyboardFocusRect {
                if bottomInset > .zero {
                    
                    if let aView = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.view {
                        let aRect = CGRect(x: keyboardFocusRect.origin.x, y: min(max(.zero, (aView.frame.height / 2 ) - (keyboardFocusRect.height / 2)), self.contentSize.height), width: keyboardFocusRect.width, height: keyboardFocusRect.height)
                        keyboardFocusRect = aView.convert(aRect, to: self)
                    }
                    self.scrollRectToVisible(keyboardFocusRect, animated: true)
                } else if bottomInset == .zero {
                    self.contentInset.bottom = bottomInset
                    self.verticalScrollIndicatorInsets.bottom = bottomInset
                } else {
                    self.scrollRectToVisible(keyboardFocusRect, animated: true)
                }
                
            } else {
                self.scrollRectToVisible(CGRect(x: self.contentSize.width - 1, y: self.contentSize.height - 1, width: 1, height: 1), animated: true)
                
            }
        })
    }
    
  }
  
}
