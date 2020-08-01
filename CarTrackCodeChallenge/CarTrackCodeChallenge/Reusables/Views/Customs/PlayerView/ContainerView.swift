//
//  ContainerView.swift
//  InstantMac
//
//  Created by Harold on 16/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import SnapKit
import RxSwift

class ContainerView: UIView {
  
  weak var parentViewController: UIViewController?
  private(set) var currentViewController: UIViewController?
  
  @discardableResult
  func transition(to viewController: UIViewController) -> Completable {
    guard currentViewController != viewController else {
      print("Transitioning to current view controller. Ignoring...")
      return .empty()
    }
    let subject = PublishSubject<Void>()

    currentViewController?.willMove(toParent: nil)
    
    parentViewController?.addChild(viewController)
    addSubview(viewController.view)
    
    viewController.view?.snp.makeConstraints({ (make) in
      make.left.equalTo(self)
      make.right.equalTo(self)
      make.top.equalTo(self)
      make.bottom.equalTo(self)
    })
    
    currentViewController?.view.removeFromSuperview()
    currentViewController?.removeFromParent()
    
    currentViewController = viewController
    
    viewController.didMove(toParent: parentViewController)
    
    subject.onCompleted()
    
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }

}
