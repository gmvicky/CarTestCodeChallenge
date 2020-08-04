//
//  ItemModelProtocol.swift
//  FrontRow
//
//  Created by WT-iOS on 1/7/20.
//  Copyright © 2020 WT-iOS. All rights reserved.
//

import Foundation
import RxDataSources

protocol ItemSkeletonable {
    var isSkeleton: Bool { get set }
}

protocol ItemModelProtocol: ItemSkeletonable, Equatable, IdentifiableType {
    func compareCheck(other: Self) -> Bool
}

extension ItemModelProtocol {
    
    func compareCheck(other: Self) -> Bool {
        return isSkeleton == other.isSkeleton ? identity == other.identity : false
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.compareCheck(other: rhs)
    }
}

protocol SectionModelProtocol {
    
    associatedtype ItemType = ItemModelProtocol
    
    var items: [ItemType] { get }
    static func skeletonItems() -> [Self]
}

extension SectionModelProtocol {
    
    static func skeletonItems() -> [Self] {
        return []
    }
}

