//
//  UIRefreshControl+.swift
//  Speshe
//
//  Created by WT-iOS on 29/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base: UIRefreshControl {
    
    public var isRefreshing2: Binder<Bool> {
        return Binder(base) { refreshControl, refresh in
            if refresh {
                
                if let scrollView = refreshControl.superview as? UIScrollView {
                    scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - refreshControl.frame.height), animated: true)
                }
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}

