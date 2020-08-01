//
//  UITableView+Reusable.swift
//  InstantMac
//
//  Created by Harold on 17/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCells(reuseIdentifiers: [String], bundle: Bundle? = nil) {
        
        reuseIdentifiers.forEach {
            let nib = UINib(nibName: $0, bundle: bundle)
            register(nib, forCellReuseIdentifier: $0)
        }
    }
    
    func register(views: [ViewReusable.Type], bundle: Bundle? = nil) {
        views.forEach { aView in
            let nib = UINib(nibName: aView.nibName, bundle: bundle)
            register(nib, forCellReuseIdentifier: aView.reuseIdentifier)
        }
    }
  
  func register<T: ViewReusable>(view: T.Type, bundle: Bundle? = nil) {
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func register<T: ViewReusable>(headerFooterView: T.Type, bundle: Bundle? = nil) {
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ViewReusable {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unable to dequeue cell with identifier \(T.reuseIdentifier)")
    }
    return cell
  }
  
  func dequeueReusableHeaderFooterView<T>() -> T where T: ViewReusable {
    guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
      fatalError("Unable to dequeue header footer view with identifier \(T.reuseIdentifier)")
    }
    return view
  }
  
}
