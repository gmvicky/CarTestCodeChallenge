//
//  CanProceedProtocol.swift
//  Speshe
//
//  Created by WT-iOS on 6/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Combine

protocol CanProceedProtocol {
    var canProceed: AnyPublisher<Bool, Never> { get }
}
