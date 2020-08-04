//
//  DetailSectionModel.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

struct DetailSectionModel {
    var items: [Item]
    var identity: Int
}

extension DetailSectionModel: AnimatableSectionModelType {
    typealias Item = DetailItemModel
    
    init(original: DetailSectionModel, items: [Item]) {
        self = original
        self.items = items
        self.identity =  original.identity
    }
    
}

extension DetailSectionModel: SectionModelProtocol {
    
    typealias ItemType = DetailItemModel
    
    static func skeletonItems() -> [DetailSectionModel] {
        
        let dummyUsers = [UserDetail(), UserDetail(), UserDetail(), UserDetail()]
        let dummyItems = dummyUsers.map { DetailItemModel(userDetail: $0, onUserDetailAction: nil) }
        
        for (index, item) in dummyItems.enumerated() {
            item.userDetail.id = index
            item.isSkeleton = true
        }

        return [DetailSectionModel(items: dummyItems, identity: 0)]
    }
}

enum UserDetailAction {
    case map
}

class DetailItemModel: ItemModelProtocol {
    
    var isSkeleton = false
    
    var identity: Int? { return userDetail.id }
    
    var userDetail: UserDetail
    
    private let onUserDetailAction: Action<(UserDetail, UserDetailAction), Void>?

    init(userDetail: UserDetail,
         onUserDetailAction: Action<(UserDetail, UserDetailAction), Void>?) {
        self.userDetail = userDetail
        self.onUserDetailAction = onUserDetailAction
    }
    
    lazy var onCustomUserAction: Action<UserDetailAction, Void> = {
        return Action { [weak self] in
            guard let userDetail = self?.userDetail else { return .empty() }
            self?.onUserDetailAction?.execute((userDetail, $0))
            return .empty()
        }
    }()
}

