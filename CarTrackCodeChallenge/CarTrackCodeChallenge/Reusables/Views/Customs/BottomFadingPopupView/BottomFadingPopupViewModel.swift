//
//  BottomFadingPopupViewModel.swift
//  FrontRow
//
//  Created by WT-iOS on 3/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation

protocol BottomFadingPopupViewModelProtocol {
    
    typealias popupStateChange = (() -> ())
    
    var customMessage: String? { get set }
    var onAppearPopup: popupStateChange? { get set }
    var onHidePopup: popupStateChange? { get set }
    
    func viewDidAppear()
}

class BottomFadingPopupViewModel: BottomFadingPopupViewModelProtocol {
    
    var customMessage: String?
    var onAppearPopup: popupStateChange?
    var onHidePopup: popupStateChange?
    
    func viewDidAppear() {
        onAppearPopup?()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.onHidePopup?()
        }
    }
    
}
