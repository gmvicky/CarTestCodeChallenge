//
//  CollectionViewHandler.swift
//  xApp
//
//  Created by WT-iOS on 11/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import RxDataSources

protocol CollectionViewHandlerDelegate: class {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

extension CollectionViewHandlerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }
}

class CollectionViewHandler: NSObject {
    
    weak var delegate: CollectionViewHandlerDelegate?
    
}

extension CollectionViewHandler: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? UICollectionViewFlowLayout.automaticSize
    }
}

//class CollectionViewHandlerIdentifiableItems<T>: NSObject, UICollectionViewDelegateFlowLayout where T: AnimatableSectionModelType {
//    
//    var collectionViewDataSource: RxCollectionViewSectionedAnimatedDataSource<T>?
//    weak var delegate: CollectionViewHandlerDelegate?
//    
//    var identifiableCellSize = [IdentifiableKey<T> : CGSize]()
//    var indexPathCellSize =  [IndexPath : CGSize]()
//    
//    init(collectionView: UICollectionView) {
//        super.init()
//        collectionView.delegate = self
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//        let size = cell.frame.size
//        
//        indexPathCellSize[indexPath] = size
//        if let identifiableKey = keyOnIndexPath(indexPath) {
//            identifiableCellSize[identifiableKey] = size
//        }
//
//    }
//    
//    estim
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return delegate?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? UICollectionViewFlowLayout.automaticSize
//    }
//    
//    private func keyOnIndexPath(_ indexPath: IndexPath) -> IdentifiableKey<T>? {
//        guard let collectionViewDataSource = collectionViewDataSource else { return nil }
//        let section = collectionViewDataSource.sectionModels[indexPath.section]
//        let item = section.items[indexPath.item]
//        let indexStruct = IdentifiableKey<T>(sectionKey: section.identity, indexKey: item.identity)
//        return indexStruct
//    }
//
//
//}


//class TableViewHandlerIdentifiableItems<T>: NSObject, UITableViewDelegate where T: AnimatableSectionModelType {
//
//
//    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<T>?
//    weak var delegate: TableViewHandlerDelegate?
//
//    var identifiableCellHeights: [IdentifiableKey<T> : CGFloat] = [:]
//    var indexPathCellHeights: [IndexPath : CGFloat] = [:]
//
//    init(tableView: UITableView) {
//        super.init()
//        tableView.delegate = self
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let height = cell.frame.size.height
//        indexPathCellHeights[indexPath] = height
//        if let identifiableKey = keyOnIndexPath(indexPath) {
//            identifiableCellHeights[identifiableKey] = height
//        }
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if let identifiableKey = keyOnIndexPath(indexPath),
//            let heightValue = identifiableCellHeights[identifiableKey] {
//            return heightValue
//        }
//        return indexPathCellHeights[indexPath] ?? 200.0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  delegate?.tableView(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
//    }
//
//    private func keyOnIndexPath(_ indexPath: IndexPath) -> IdentifiableKey<T>? {
//        guard let tableViewDataSource = tableViewDataSource else { return nil }
//        let section = tableViewDataSource.sectionModels[indexPath.section]
//        let item = section.items[indexPath.item]
//        let indexStruct = IdentifiableKey<T>(sectionKey: section.identity, indexKey: item.identity)
//        return indexStruct
//    }
//
//    struct IdentifiableKey<T>: Hashable where T: AnimatableSectionModelType {
//        let sectionKey: T.Identity
//        let indexKey: T.Item.Identity
//    }
//}
//
//
