//
//  UIView+EmptyView.swift
//  InstantMac
//
//  Created by Harold on 27/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIView {
  
  var emptyView: UIView? {
    return subviews.first(where: { $0 is EmptyViewLoadable })
  }

  func showEmptyView(_ emptyViewType: EmptyViewType) {
    hideEmptyView()
    let view = emptyViewType.view()
    addSubview(view)
    view.snp.makeConstraints { maker in
        
      maker.edges.equalToSuperview().priority(.medium)
      maker.size.equalToSuperview()
    }
  }

  func updateEmptyViewOffset(_ offset: UIEdgeInsets) {
    emptyView?.snp.remakeConstraints { maker in
        
      maker.top.equalToSuperview().offset(offset.top).priority(.medium)
      maker.bottom.equalToSuperview().offset(offset.bottom).priority(.medium)
      maker.left.equalToSuperview().offset(offset.left).priority(.medium)
      maker.right.equalToSuperview().offset(offset.right).priority(.medium)
      
      let heightOffset = offset.top + offset.bottom
      let widthOffset = offset.left + offset.right
      maker.height.equalToSuperview().offset(-heightOffset)
      maker.width.equalToSuperview().offset(-widthOffset)
    }
  }
  
  func updateEmptyViewSizeOffset(_ size: CGSize) {
    emptyView?.snp.remakeConstraints { maker in
      maker.edges.equalToSuperview().priority(.medium)
      maker.height.equalToSuperview().offset(-size.height)
      maker.width.equalToSuperview().offset(-size.width)
    }
  }

  func hideEmptyView() {
    emptyView?.removeFromSuperview()
  }
  
  
  
}
