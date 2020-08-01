//
//  DeleteIndexPathReceiver.swift
//  FrontRow
//
//  Created by WT-iOS on 11/10/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action

protocol DeleteIndexPathActionReceiver: class {
    
    associatedtype TableSectionType: SectionModelType
    
    var sectionsRelay: BehaviorRelay<[TableSectionType]> { get }
    var onDeleteItemAtIndexPath: Action<IndexPath, Void>  { get }
    var itemsRemainingAfterDeleteSubject: PublishSubject<[TableSectionType]> { get }
    var deletedIndexPathSubject: PublishSubject<IndexPath> { get }
}

extension DeleteIndexPathActionReceiver {
    
    func deleteItemAtItemPathAction() -> Action<IndexPath,Void> {
        
        return Action { [weak self] indexPath in
            guard let `self` = self else { return .empty() }
            self.deletedIndexPathSubject.onNext(indexPath)
            let currentSection = self.sectionsRelay.value[indexPath.section]
            var currentItems = currentSection.items
            currentItems.remove(at: indexPath.item)
            let newSection = TableSectionType(original: currentSection, items: currentItems)
            var allSections = self.sectionsRelay.value
            allSections[indexPath.section] = newSection
            self.itemsRemainingAfterDeleteSubject.onNext(allSections)
            
            return .empty()
        }
    }
}
