//
//  ViewReusable.swift
//  InstantMac
//
//  Created by Harold on 17/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit

protocol ViewReusable {
  
  static var nibName: String { get }
  static var reuseIdentifier: String { get }
}

extension ViewReusable where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
