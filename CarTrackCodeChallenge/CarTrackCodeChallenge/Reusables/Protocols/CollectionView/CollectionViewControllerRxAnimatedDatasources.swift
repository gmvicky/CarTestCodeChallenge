//
//  CollectionViewControllerRxAnimatedDatasources.swift
//  xApp
//
//  Created by WT-iOS on 8/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import Action

protocol CollectionViewConfigurator {
    func configureCollectionView(_ collectionView: UICollectionView)
}

protocol CollectionViewControllerRxAnimatedDatasources: class {
    
    associatedtype CollectionSectionType: AnimatableSectionModelType
    
    var collectionViewDataSource: RxCollectionViewSectionedAnimatedDataSource <CollectionSectionType>? { get set }
    var sectionModels: Observable<[CollectionSectionType]>? { get }
    var cellConfiguration: RxCollectionViewSectionedAnimatedDataSource<CollectionSectionType>.ConfigureCell? { get }
    var cellTypes: [ViewReusable.Type] { get }
    var emptyViewType: EmptyViewType? { get }
    var edgeInsets: UIEdgeInsets? { get }
    var onIndexPathSelected: Action<IndexPath,Void>? { get }
    var collectionDisposeBag: DisposeBag { get set }
    
    var canEditRowAtIndexPath: ((CollectionViewSectionedDataSource<CollectionSectionType>, IndexPath) -> Bool) { get }
    func configureCollectionView(_ collectionView: UICollectionView)
    func resetCollectionDisposeBag()
}

extension CollectionViewControllerRxAnimatedDatasources {
    
    var emptyViewType: EmptyViewType? { return nil }
    var edgeInsets: UIEdgeInsets? { return nil }
    var onIndexPathSelected: Action<IndexPath,Void>? { return nil }
    
    func configureCollectionView(_ collectionView: UICollectionView) {
        loadCollection(collectionView)
    }
    
    func resetCollectionDisposeBag() {
        collectionDisposeBag = DisposeBag()
    }
    var canEditRowAtIndexPath: ((CollectionViewSectionedDataSource<CollectionSectionType>, IndexPath) -> Bool) {
        return { (_, _) in return false }
    }
    
    
    
    func loadCollection(_ collectionView: UICollectionView) {
        collectionView.register(views: cellTypes)
        collectionDisposeBag = DisposeBag()
//        collectionView.dataSource = nil //
//        collectionView.delegate = nil //
        
        if collectionViewDataSource == nil {
            guard let cellConfiguration = cellConfiguration else { return }
            
            collectionViewDataSource = RxCollectionViewSectionedAnimatedDataSource.init(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade), configureCell: cellConfiguration)
        }
        
        guard let sectionModels = sectionModels,
            let collectionViewDataSource = collectionViewDataSource else { return }
        
        let sections = sectionModels
            .asDriver(onErrorJustReturn: [])
        
        sections
            .drive(collectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: collectionDisposeBag)
        
        let emptyView = sections
            .map { $0.areSectionsEmpty }
            .map { [weak self] isEmpty -> EmptyViewType? in
                guard let `self` = self else { return nil }
                return isEmpty ? (self.emptyViewType ?? nil) : nil
        }
        
        emptyView
            .do(onNext: { aEmptyView in
                collectionView.isScrollEnabled = aEmptyView == nil
            })
            .drive(collectionView.rx.emptyView)
            .disposed(by: collectionDisposeBag)
        
        emptyView
            .map { [weak self] _ -> UIEdgeInsets in
                guard let insets = self?.edgeInsets else { return UIEdgeInsets.zero }
                return insets }
            .drive(collectionView.rx.emptyViewOffset)
            .disposed(by: collectionDisposeBag)
        
        if let onIndexPathSelected = onIndexPathSelected {
            collectionView.rx.itemSelected
                .do(onNext: {
                    collectionView.deselectItem(at: $0, animated: true)
                })
                .bind(to: onIndexPathSelected.inputs)
                .disposed(by: collectionDisposeBag)
        }
    }
    
}
