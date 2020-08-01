//
//  TableViewControllerRxAnimatedDatasources.swift
//  xApp
//
//  Created by WT-iOS on 5/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import Action

protocol TableViewControllerRxAnimatedDatasources: class {
    
    associatedtype TableSectionType: AnimatableSectionModelType
    
    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<TableSectionType>? { get set }
    var sectionModels: Observable<[TableSectionType]>? { get }
    var cellConfiguration: RxTableViewSectionedAnimatedDataSource<TableSectionType>.ConfigureCell? { get }
    var cellTypes: [ViewReusable.Type] { get }
    var emptyViewType: EmptyViewType? { get }
    var edgeInsets: UIEdgeInsets? { get }
    var onIndexPathSelected: Action<IndexPath,Void>? { get }
    var canEditRowAtIndexPath: ((TableViewSectionedDataSource<TableSectionType>, IndexPath) -> Bool) { get }
    func configureTableView(_ tableView: UITableView)
    var animationConfiguration: AnimationConfiguration { get }
    var collectionDisposeBag: DisposeBag { get set }
    var onRefresh: CocoaAction? { get }
}

extension TableViewControllerRxAnimatedDatasources {
    
    var emptyViewType: EmptyViewType? { return nil }
    var edgeInsets: UIEdgeInsets? { return nil }
    var onIndexPathSelected: Action<IndexPath,Void>? { return nil }
    var canEditRowAtIndexPath: ((TableViewSectionedDataSource<TableSectionType>, IndexPath) -> Bool) {
        return { (_, _) in return false }
    }
    var animationConfiguration: AnimationConfiguration { return AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .middle) }
    var onRefresh: CocoaAction? { return nil }
    
    func configureTableView(_ tableView: UITableView) {
        loadTable(tableView)
    }
    
    func loadTable(_ tableView: UITableView) {
        tableView.register(views: cellTypes)
        collectionDisposeBag = DisposeBag()
        
        if tableViewDataSource == nil {
            guard let cellConfiguration = cellConfiguration else { return }
            
            tableViewDataSource = RxTableViewSectionedAnimatedDataSource.init(animationConfiguration: animationConfiguration, configureCell: cellConfiguration, canEditRowAtIndexPath: canEditRowAtIndexPath)
        }
        
        guard let sectionModels = sectionModels,
            let tableViewDataSource = tableViewDataSource else { return }
        
        let sections = sectionModels
            .asDriver(onErrorJustReturn: [])
        
        sections
            .drive(tableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: collectionDisposeBag)
        
        let emptyView = sections
            .map { $0.areSectionsEmpty }
            .map { [weak self] isEmpty -> EmptyViewType? in
                guard let `self` = self else { return nil }
                return isEmpty ? (self.emptyViewType ?? nil) : nil
        }
        
        emptyView
            .do(onNext: { aEmptyView in
                tableView.isScrollEnabled = aEmptyView == nil
            })
            .drive(tableView.rx.emptyView)
            .disposed(by: collectionDisposeBag)
        
        emptyView
            .map { [weak self] _ -> UIEdgeInsets in
                guard let insets = self?.edgeInsets else { return UIEdgeInsets.zero }
                return insets }
            .drive(tableView.rx.emptyViewOffset)
            .disposed(by: collectionDisposeBag)
        
        if let onIndexPathSelected = onIndexPathSelected {
            tableView.rx.itemSelected
                .do(onNext: {
                    tableView.deselectRow(at: $0, animated: true)
                })
                .bind(to: onIndexPathSelected.inputs)
                .disposed(by: collectionDisposeBag)
        } else {
            tableView.allowsSelection = false
        }
        
        if let onRefresh = onRefresh {
            let refreshControl = tableView.refreshControl ?? UIRefreshControl()
            if tableView.refreshControl == nil {
                tableView.refreshControl = refreshControl
            }
            
            onRefresh.executing
                .asDriver(onErrorJustReturn: false)
                .drive(refreshControl.rx.isRefreshing2)
                .disposed(by: collectionDisposeBag)
            
            refreshControl.rx.controlEvent(.valueChanged)
                .bind(to: onRefresh.inputs)
                .disposed(by: collectionDisposeBag)
        }
    }
}

extension Array where Element: AnimatableSectionModelType {
    
    public var areSectionsEmpty: Bool {
        return !( map { $0.items.isEmpty }.contains(false))
    }
}
