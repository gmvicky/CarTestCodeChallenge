//
//  UIView+Rx.swift
//  InstantMac
//
//  Created by Harold on 30/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {

  var backgroundColor: Binder<UIColor?> {
    return Binder(base) { view, backgroundColor in
      view.backgroundColor = backgroundColor
    }
  }
  
  var borderColor: Binder<UIColor?> {
    return Binder(base) { view, borderColor in
      view.layer.borderColor = borderColor?.cgColor
    }
  }
  
  var emptyView: Binder<EmptyViewType?> {
    return Binder(base) { view, emptyView in
      if let emptyView = emptyView {
        view.showEmptyView(emptyView)
      } else {
        view.hideEmptyView()
      }
    }
  }
  
  var emptyViewOffset: Binder<UIEdgeInsets> {
    return Binder(base) { view, offset in
      view.updateEmptyViewOffset(offset)
    }
  }
  
  var emptyViewSizeOffset: Binder<CGSize> {
    return Binder(base) { view, size in
      view.updateEmptyViewSizeOffset(size)
    }
  }
  
  var isSpinnerHidden: Binder<Bool> {
    return Binder(base) { view, isSpinnerHidden in
      if isSpinnerHidden {
        Spinner.hide(for: view)
      } else {
        Spinner.show(in: view)
      }
    }
  }
  
}
