//
//  InputError.swift
//  PinGo
//
//  Created by WT-iOS on 8/1/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation

struct InputError {
    enum ErrorType {
        case empty(shouldShowWhenEmpty: Bool)
        case insufficientNumberOfCharacters(Int)
        case notMatching(InputObject)
        case passwordCombinationError
        case emailFormatNotValid
    }
    
    var errorType: ErrorType
}


extension InputError.ErrorType {
    var errorDescription: String? {
        switch self {
        case .empty(let flag):
            return flag ? "Field is empty" : nil
        case .insufficientNumberOfCharacters(let count):
            return "Must be atleast \(count) characters"
        case .notMatching:
            return "Input not matching"
        case .passwordCombinationError:
            return "Must be atleast 8 characters and have atleast 1 lower, uppercase letter, 1 number, and 1 symbol"
        case .emailFormatNotValid:
            return "Email format not valid"
        }
    }
}
//
//extension InputError.ErrorType: Equatable {
//    static func == (lhs: InputError.ErrorType, rhs: InputError.ErrorType) -> Bool {
//        switch (lhs, rhs) {
//        case (.empty, .empty):
//            return true
//        case (.insufficientNumberOfCharacters(let aCount), .insufficientNumberOfCharacters(let bCount)):
//            return aCount == bCount
//        default:
//            return false
//        }
//    }
//}
