//
//  UIView+fade.swift
//  FrontRow
//
//  Created by WT-iOS on 3/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func fadeAlternateViews(viewsToShow: [UIView?], viewsToHide: [UIView?], duration: TimeInterval = 1.0, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        
        viewsToShow.forEach { $0?.alpha = 0 }
        viewsToShow.forEach { $0?.isHidden = false }
        
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            viewsToShow.forEach { $0?.alpha = 1 }
            viewsToHide.forEach { $0?.alpha = 0 }
        }, completion: { flag in
            viewsToHide.forEach { $0?.isHidden = true }
            completion?(flag)
        })
    }
    
    func fadeViewInThenOut(delay: TimeInterval) {
        
        let animationDuration = 1.5
        
        UIView.animate(withDuration: animationDuration, delay: delay, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: { [weak self] in
            self?.alpha = 0
        }, completion: nil)
        
    }
    
    func fadeInOrOutAutomatic(shouldShow: Bool, duration: TimeInterval = 0.3) {
        if shouldShow {
            alpha = 0
            isHidden = false
            fadeIn(duration: duration)
        } else {
            alpha = 1
            isHidden = false
            fadeOut(duration: duration) { [weak self] _ in
                self?.isHidden = true
            }
        }
        
    }
    
    
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        self.alpha = 0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func toggleViewVisibility(shouldShow: Bool, duration: CGFloat = 0.3, completion: (() -> ())? = nil) {
        
        if shouldShow {
            isHidden = false
            alpha = 0
            fadeIn(duration: 0.3, delay: 0, completion: { flag in
                if flag {
                    completion?()
                }
            })
        } else {
            fadeOut(duration: 0.3, delay: 0, completion: { [weak self] flag in
                if flag {
                    completion?()
                    self?.isHidden = true
                }
            })
        }
        
    }
    
    func fadeInOrOutAutomatic(withContainerView containerView: UIView, shouldShow: Bool, duration: TimeInterval = 0.3) {
        if shouldShow {
            alpha = 0
            isHidden = false
            fadeIn(withContainerView: containerView, duration: duration)
        } else {
            alpha = 1
            isHidden = false
            fadeOut(withContainerView: containerView, duration: duration) { [weak self] _ in
                self?.isHidden = true
            }
        }
    }
    
    func fadeIn(withContainerView containerView: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        DispatchQueue.main.async {
            UIView.transition(with: containerView, duration: duration, options: .curveEaseIn, animations: {
                self.alpha = 1
            }, completion: completion)
        }
    }
    
    func fadeOut(withContainerView containerView: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        DispatchQueue.main.async {
            UIView.transition(with: containerView, duration: duration, options: .curveEaseIn, animations: {
                self.alpha = 0
            }, completion: completion)
        }
    }
}
