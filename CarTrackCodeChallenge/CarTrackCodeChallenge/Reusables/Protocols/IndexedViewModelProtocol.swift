//
//  IndexedItemProtocol.swift
//  Speshe
//
//  Created by WT-iOS on 31/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

protocol IndexedViewModelProtocol: BaseViewModelProtocol {
    var index: Int { get set }
    var pagedViewController: UIViewController? { get }
    var itemTitle: String? { get }
}
//
//extension IndexedViewModelProtocol {
//    static func index(of viewController: UIViewController) -> Int? {
//        return viewController.indexItemModel()?.index
//    }
//}

protocol IndexedViewControllerProtocol {
    var indexedViewModel: IndexedViewModelProtocol? { get }
}


extension UIViewController {
    
    func indexItemModel<T: IndexedViewModelProtocol>(type: T.Type) -> IndexedViewModelProtocol? {
        
        guard let vc = self as? BaseViewController<T>,
            let item = vc.viewModel else { return nil }
        
        return item
    }
}

class IndexedViewModel: BaseViewModel, IndexedViewModelProtocol {
   
    var itemTitle: String? { return nil }
    
    
    var index: Int = 0
    var pagedViewController: UIViewController? {
        return router.viewController
    }
}
