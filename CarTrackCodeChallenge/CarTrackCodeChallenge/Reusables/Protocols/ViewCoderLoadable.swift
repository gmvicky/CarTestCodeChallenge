//
//  ViewCoderLoadable.swift
//  InstantMac
//
//  Created by Harold on 21/03/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import SnapKit

protocol ViewCoderLoadable {
  func setUpLoadableView()
}

extension ViewCoderLoadable where Self: UIView {
  
    static var bundle: Bundle {
        return Bundle(for: self.classForCoder())
    }
    
  func setUpLoadableView() {
    if let view = viewFromNib() {
      addSubview(view)
      view.snp.makeConstraints({ (make) in
        make.edges.equalTo(self)
      })
    }
  }
  
  private func viewFromNib() -> UIView? {
    
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: Self.bundle)
    if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
      return view
    }
    return nil
  }
  
}
