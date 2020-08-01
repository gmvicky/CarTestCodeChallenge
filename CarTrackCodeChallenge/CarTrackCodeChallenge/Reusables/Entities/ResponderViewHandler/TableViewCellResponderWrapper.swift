//
//  TableViewCellResponderWrapper.swift
//  Speshe
//
//  Created by WT-iOS on 28/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class TableViewCellResponderWrapper: ResponderWrapper {
    
    weak var cell: UITableViewCell?
    weak var tableView: UITableView?
    
    init(cell: UITableViewCell,
         tableView: UITableView?,
         tag: Int = 0 ,
         characterSetLimiter: [CharacterSet]? = nil,
         maxCount: Int? = nil,
         shouldCheckWhenValid: Bool = true) {
        self.cell = cell
        self.tableView = tableView
        super.init(responder: cell, tag: tag, characterSetLimiter: characterSetLimiter, maxCount: maxCount, shouldCheckWhenValid: shouldCheckWhenValid)
    }
    
    override func customAction() {
        if let aCell = cell,
            let aTableView = tableView,
            let index = aTableView.indexPath(for: aCell) {
            aTableView.delegate?.tableView?(aTableView, didSelectRowAt: index)
        }
        
    }
}

