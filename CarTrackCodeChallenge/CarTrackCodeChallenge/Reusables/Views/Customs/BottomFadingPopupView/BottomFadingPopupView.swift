//
//  BottomFadingPopupView.swift
//  FrontRow
//
//  Created by WT-iOS on 3/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit

class BottomFadingPopupView: UIView {
    
    private struct Constants {
        static let bottomPopupFadeDuration = Double(1.5)
    }
    
    var popupViewModel: BottomFadingPopupViewModelProtocol?
    
    @IBOutlet weak var messageBoxParentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        bindViewModels()
        popupViewModel?.viewDidAppear()
    }
    
    // MARK: - Private
    
    private func bindViewModels() {
        messageLabel.text = popupViewModel?.customMessage
        messageBoxParentView.setNeedsLayout()
        messageBoxParentView.roundCorners()
        popupViewModel?.onAppearPopup = { [weak self] in
            DispatchQueue.main.async {
                self?.showPopup()
            }
        }
        
        popupViewModel?.onHidePopup = { [weak self] in
            DispatchQueue.main.async {
                self?.dismissPopup()
            }
        }
    }
    
    private func showPopup() {
       messageBoxParentView.fadeIn(duration: Constants.bottomPopupFadeDuration, delay: 0)
    }
    
    private func dismissPopup() {
        messageBoxParentView.fadeOut(duration: Constants.bottomPopupFadeDuration, delay: 0) { [weak self] (flag) in
            if flag {
                self?.removeFromSuperview()
            }
        }
    }
}
