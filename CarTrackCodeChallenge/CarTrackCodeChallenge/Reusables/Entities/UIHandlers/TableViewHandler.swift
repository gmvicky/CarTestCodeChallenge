//
//  TableViewHandler.swift
//  xApp
//
//  Created by WT-iOS on 8/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import RxDataSources

protocol TableViewHandlerDelegate: class {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath]
    
}

extension TableViewHandlerDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return .zero }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return nil }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) { }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool { return false }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        return []
    }
}

class TableViewHandlerIdentifiableItems<T>: NSObject, UITableViewDelegate, UITableViewDataSourcePrefetching where T: AnimatableSectionModelType {
    
    
    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<T>?
    weak var delegate: TableViewHandlerDelegate?
    
    var identifiableCellHeights: [IdentifiableKey<T> : CGFloat] = [:]
    var indexPathCellHeights: [IndexPath : CGFloat] = [:]
    
    
    init(tableView: UITableView) {
        super.init()
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = cell.frame.size.height
        indexPathCellHeights[indexPath] = height
        if let identifiableKey = keyOnIndexPath(indexPath) {
            identifiableCellHeights[identifiableKey] = height
        }
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let identifiableKey = keyOnIndexPath(indexPath),
            let heightValue = identifiableCellHeights[identifiableKey] {
            return heightValue
        }
        return indexPathCellHeights[indexPath] ?? UserDetailTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  delegate?.tableView(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.tableView(tableView, heightForHeaderInSection: section) ??  .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate?.tableView(tableView, viewForHeaderInSection: section) ?? nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.tableView(tableView, heightForFooterInSection: section) ??  .zero
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegate?.tableView(tableView, viewForFooterInSection: section) ?? nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate?.tableView(tableView, prefetchRowsAt: indexPaths)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return delegate?.isLoadingCell(for: indexPath) ?? false
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
//        guard let aDelegate = delegate else { return [] }
        return []
//      let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
//      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
//      return Array(indexPathsIntersection)
    }
    
    
    
    // MARK: - Private
    
    private func keyOnIndexPath(_ indexPath: IndexPath) -> IdentifiableKey<T>? {
        guard let tableViewDataSource = tableViewDataSource else { return nil }
        let section = tableViewDataSource.sectionModels[indexPath.section]
        let item = section.items[indexPath.item]
        let indexStruct = IdentifiableKey<T>(sectionKey: section.identity, indexKey: item.identity)
        return indexStruct
    }
}

struct IdentifiableKey<T>: Hashable where T: AnimatableSectionModelType {
    let sectionKey: T.Identity
    let indexKey: T.Item.Identity
}


