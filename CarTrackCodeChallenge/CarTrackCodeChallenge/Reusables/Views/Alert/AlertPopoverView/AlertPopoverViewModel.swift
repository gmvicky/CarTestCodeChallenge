//
//  AlertPopoverViewModel.swift
//  Speshe
//
//  Created by WT-iOS on 30/5/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources

protocol AlertPopoverViewModelProtocol: TableViewConfigurator, IndexPathActionReceiver {
    var onClose: CocoaAction { get }
}

class AlertPopoverViewModel: AlertPopoverViewModelProtocol {
    
    let indexPathSubject = PublishSubject<IndexPath>()
    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<AlertTableSectionModel>?
    var collectionDisposeBag = DisposeBag()
    
    private let sectionsRelay = BehaviorRelay(value: [AlertTableSectionModel]())
    private let alert: AlertTagStructure
    private weak var view: UIView?
    private let disposeBag = DisposeBag()
    
    init(view: UIView,
        alert: AlertTagStructure) {
        self.view = view
       self.alert = alert
        initialLoad()
    }
    
    var sections: Observable<[AlertTableSectionModel]> {
        return sectionsRelay.asObservable()
    }
    
    func initialLoad() {
        var alertSections = [AlertTableSectionModel]()
        if let title = alert.title {
            alertSections.append(AlertTableSectionModel(items: [AlertItemModelText(message: title, fontType: .bold)], identity: 0) )
        }
        
        if let message = alert.message {
            alertSections.append(AlertTableSectionModel(items: [AlertItemModelText(message: message, fontType: .regular)], identity: 1) )
        }
        
        if !alert.options.isEmpty {
            let alertItems = alert.options.compactMap { [weak self] aAlert -> AlertItemModel? in
                switch aAlert.alertOptionType {
                case .normalCell:
                    return AlertItemModelOption(alertOption: aAlert, closeAction:  self?.onClose)
                case .radioButton:
                    if let checkBox = aAlert as? AlertCheckBoxOption {
                        return AlertItemCheckboxModel(alertOption: checkBox, closeAction:  self?.onClose)
                    }
                    return nil
                }
            }
            alertSections.append(AlertTableSectionModel(items: alertItems, identity: 2) )
        }
        sectionsRelay.accept(alertSections)
        
        indexPathSubject
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                let allItemsInSection = self.sectionsRelay.value[indexPath.section].items
                let item = allItemsInSection[indexPath.row]
                if let checkboxItem = item as? AlertItemCheckboxModel {
                    for (index, eachItem) in allItemsInSection.enumerated() {
                        if let deselectedItem = eachItem as? AlertItemCheckboxModel, index != indexPath.row {
                            deselectedItem.checkBox.isSelectedRelay.accept(false)
                        }
                    }
                    checkboxItem.checkBox.isSelectedRelay.accept(!checkboxItem.checkBox.isSelectedRelay.value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    lazy var onClose: CocoaAction = {
        return CocoaAction { [weak self] in
            self?.view?.fadeOut(duration: 0.3, completion: { [weak self] (_) in
                self?.view?.removeFromSuperview()
            })
            return .empty()
        }
    }()
    
    // MARK: - IndexPathActionReceiver
    
    lazy var onIndexPathSelected: Action<IndexPath, Void>? = {
       return indexPathSelectedAction()
    }()
    
    func indexPathSelected(_ indexPath: IndexPath) {

    }
}


extension AlertPopoverViewModel: TableViewControllerRxAnimatedDatasources {
    
    var sectionModels: Observable<[AlertTableSectionModel]>? {
        return sectionsRelay.asObservable()
    }
    
    var cellConfiguration: ((TableViewSectionedDataSource<AlertTableSectionModel>, UITableView, IndexPath, AlertTableSectionModel.Item) -> UITableViewCell)? {
        return { (_, tableView, indexPath , item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
            
            if var aCell = cell as? AlertItemCellProtocol {
                aCell.item = item
            }
            if var aCell = cell as? TableViewCellUpdateHeightProtocol {
                aCell.updateHeight = { tableViewCell in
                    if let indexPath = tableView.indexPath(for: tableViewCell) {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            return cell
        }
    }
    
    var cellTypes: [ViewReusable.Type] {
        return [AlertTableViewCellText.self, AlertTableViewCellOption.self,
                AlertTableViewCellCheckbox.self]
    }
    
}
