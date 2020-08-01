//
//  ItemHeightProtocol.swift
//  xApp
//
//  Created by WT-iOS on 24/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit

protocol ItemHeightProtocol {
    var preferredHeight: CGFloat? { get }
}

protocol ItemSizeProtocol {
    var preferredSize: CGSize? { get }
}
