//
//  TableViewCell+UpdateHeight.swift
//  xApp
//
//  Created by WT-iOS on 13/1/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

protocol TableViewCellUpdateHeightProtocol {
    var updateHeight: ((UITableViewCell)-> ())? { get set }
}
