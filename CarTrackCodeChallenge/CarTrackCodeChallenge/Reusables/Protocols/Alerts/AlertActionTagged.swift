//
//  AlertAction.swift
//  InstantMac
//
//  Created by Paul Sevilla on 06/08/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

struct AlertActionTagged {
  var title: String?
  var tag: Int
    var style: UIAlertAction.Style
  
    static func action(title: String?, tag: Int, style: UIAlertAction.Style = .default) -> AlertActionTagged {
    return AlertActionTagged(title: title, tag: tag, style: style)
  }
}
