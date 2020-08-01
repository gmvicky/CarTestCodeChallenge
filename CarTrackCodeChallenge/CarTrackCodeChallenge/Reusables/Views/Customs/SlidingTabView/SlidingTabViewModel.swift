//
//  SlidingTabViewModel.swift
//  Speshe
//
//  Created by WT-iOS on 27/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import Combine

protocol SlidingTabViewModelProtocol: class {
    var items: [(RouterProtocol, String)] { get }
    var headerCellTypes: [ViewReusable.Type] { get }
    var headerHandler: SlidingTabCollectionHandler<String> { get }
    var contentHandler: SlidingTabCollectionHandler<UIViewController> { get }
    var currentSlidingItemTypeRelay: CurrentValueSubject<Int, Never> { get }
}

extension SlidingTabViewModelProtocol {
    
    func onDidSelect(itemIndex: Int, tabType: SlidingTabType) {
        currentSlidingItemTypeRelay.send(itemIndex)
        let path = IndexPath(item: itemIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if case .header(let style) = self.headerHandler.slidingTabType,
                style == .flexible {
                self.headerHandler.collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            }
            self.headerHandler.collectionView?.reloadData()
            self.contentHandler.collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
          }
    }
    
    func configureTabs(header: UICollectionView,
                       content: UICollectionView) {
        let viewControllers = items.compactMap { $0.0.viewController }
        let titles = items.compactMap { $0.1 }
        guard viewControllers.count == titles.count else { return }
        
        content.isPagingEnabled = true
        headerHandler.configure(collectionView: header, cellTypes: headerCellTypes)
        contentHandler.configure(collectionView: content)
        headerHandler.reloadItems(items: titles)
        contentHandler.reloadItems(items: viewControllers)
    }
}
