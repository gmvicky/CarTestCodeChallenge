//
//  UIResponder.swift
//  xApp
//
//  Created by WT-iOS on 21/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit

public extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}
