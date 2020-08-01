//
//  IndexPathActionReceiver.swift
//  FrontRow
//
//  Created by WT-iOS on 18/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol IndexPathActionReceiver: class {
    
    var onIndexPathSelected: Action<IndexPath, Void>? { get }
    var indexPathSubject: PublishSubject<IndexPath> { get }
    
}

extension IndexPathActionReceiver {
    
    func indexPathSelectedAction() ->  Action<IndexPath, Void> {
        return Action { [weak self] indexPath in
            self?.indexPathSubject.onNext(indexPath)
            return .empty()
        }
    }
}

