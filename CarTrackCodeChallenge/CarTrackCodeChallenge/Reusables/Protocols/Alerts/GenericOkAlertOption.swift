//
//  GenericOkAlertOption.swift
//  DinDinn
//
//  Created by DD_01 on 11/3/19.
//  Copyright © 2019 DinDinn. All rights reserved.
//

import Foundation
import UIKit

enum GenericAlertOption<T>: AlertOptionProtocol {
    
    case ok(T?, ((T?)->())?)
    case cancel(T?, ((T?)->())?)
    case yes(T?, ((T?)->())?)
    case no(T?, ((T?)->())?)
    case okCancel(T?, ((T?)->())?)
    
    
    var style: UIAlertAction.Style {
        switch self {
        case .ok, .yes:
            return .default
        case .cancel, .no, .okCancel:
            return .cancel
        }
    }
    
    
    var title: String? {
        switch self {
        case .ok, .okCancel: return "Ok"
        case .cancel: return "Cancel"
        case .yes: return "Yes"
        case .no: return "No"
        }
    }
    
    func customAction() {
        switch self {
        case let .ok(value, completion),
            let .cancel(value, completion),
            let .yes(value, completion),
            let .no(value, completion),
            let .okCancel(value, completion):
            completion?(value)
        }
    }
}
