//
//  Spinner.swift
//  InstantMac
//
//  Created by Harold on 16/07/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit
//import MBProgressHUD

class Spinner {
  
  private struct Constants {
    static let defaultBackgroundViewColor = UIColor.darkGray// UIColor.rgb(85.0, alpha: 0.15)
  }
  
  class func show(in view: UIView?,
                 title: String? = nil,
                 subtitle: String? = nil,
                 duration: TimeInterval = 0.0) {
//    guard let view = view else {
//      return
//    }
//    view.isUserInteractionEnabled = false
//
//    let hud = MBProgressHUD.showAdded(to: view, animated: true)
//    hud.mode = .indeterminate
//    hud.label.text = title
//    hud.detailsLabel.text = subtitle
//    hud.bezelView.color = .white
//    hud.backgroundView.color = Constants.defaultBackgroundViewColor
//    hud.completionBlock = {
//      view.isUserInteractionEnabled = true
//    }
//
//    if duration > 0.0 {
//      hud.hide(animated: true, afterDelay: duration)
//    }
  }
  
  class func hide(for view: UIView?, animated: Bool = true) {
//    guard let view = view else {
//      return
//    }
//    MBProgressHUD.hide(for: view, animated: animated)
//    view.isUserInteractionEnabled = true
  }
  
}
