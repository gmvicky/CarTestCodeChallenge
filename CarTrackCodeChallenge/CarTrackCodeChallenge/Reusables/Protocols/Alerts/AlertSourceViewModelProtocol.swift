//
//  AlertSourceViewModelProtocol.swift
//  FrontRow
//
//  Created by WT-iOS on 18/10/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import RxSwift

protocol AlertSourceViewModelProtocol {
    
    var alertsSourceSubject: PublishSubject<AlertTagStructure> { get }
}
