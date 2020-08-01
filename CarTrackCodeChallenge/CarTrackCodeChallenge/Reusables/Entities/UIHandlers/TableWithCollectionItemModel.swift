//
//  TableWithCollectionItemModel.swift
//  xApp
//
//  Created by WT-iOS on 24/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Action

protocol TableWithCollectionItemModelProtocol {
    
    associatedtype T: AnimatableSectionModelType
    
    var item: TableWithCollectionItemModel<T> { get }
}

class TableWithCollectionItemModel<T>: IndexPathActionReceiver, ItemHeightProtocol, ItemSizeProtocol, CollectionViewControllerRxAnimatedDatasources where T: AnimatableSectionModelType {
    
    let indexPathSubject = PublishSubject<IndexPath>()
    let sectionRelay = BehaviorRelay(value: [T]())
    var collectionViewDataSource: RxCollectionViewSectionedAnimatedDataSource <T>?
    var collectionDisposeBag = DisposeBag()
    var preferredHeight: CGFloat? { return nil }
    var preferredSize: CGSize? { return nil }
    var indexPathDisposeBag = DisposeBag()
    
    init(items: [T]) {
        sectionRelay.accept(items)
        customSetup()
    }
    
    deinit {
        print("\(String(describing: self)) deinitialized")
    }
    
    var sectionModels: Observable<[T]>? {
        return sectionRelay.asObservable()
        
    }
    
    func customSetup() { }
    
    func configureCollectionView(_ collectionView: UICollectionView) {
        loadCollection(collectionView)
    }
    
    func resetCollectionDisposeBag() {
        collectionDisposeBag = DisposeBag()
    }
    
    lazy var onIndexPathSelected: Action<IndexPath, Void>? = {
        return indexPathSelectedAction()
    }()
    
    var emptyViewType: EmptyViewType? { return nil }
    var edgeInsets: UIEdgeInsets? { return nil }
    
    var cellConfiguration: ((CollectionViewSectionedDataSource<T>, UICollectionView, IndexPath, T.Item) -> UICollectionViewCell)? {
        return { (_, collectionView, indexPath , item) in
            return UICollectionViewCell()
        }
    }
    
    var cellTypes: [ViewReusable.Type] {
        return []
    }
}
