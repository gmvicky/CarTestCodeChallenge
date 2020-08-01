//
//  StringToFloatEntryProtocol.swift
//  FrontRow
//
//  Created by WT-iOS on 9/10/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol StringToFloatEntryProtocol {
    var currentInputRelay: BehaviorRelay<String?> { get }
    var currentAmountRelay: BehaviorRelay<Float?> { get }
    var currentAmount: Observable<Float> { get }
    var disposeBag: DisposeBag { get }
    var formattedInputAmount: Observable<String?> { get }
    var currentAmountCanProceed: Observable<Bool> { get }
}

extension StringToFloatEntryProtocol {
    
    var currentAmount: Observable<Float>  { return currentAmountRelay.unwrap() }
    
    var currentAmountCanProceed: Observable<Bool> {
        return currentAmountRelay
            .map { $0 != nil }
    }
    
    func observeStringToFloatEntries() {
        currentInputRelay
            .map { inputString -> Float? in
                return inputString?.commaWithDecimals?.floatValue
            }
            .bind(to: currentAmountRelay)
            .disposed(by: disposeBag)
    }
    
    var formattedInputAmount: Observable<String?> {
        return Observable.combineLatest(currentInputRelay, currentAmount)
            .map {
                guard let inputString = $0.0,
                    let _ = inputString.commaWithDecimals?.floatValue,
                    inputString.last != String.formatterDecimalAndCommas.decimalSeparator.last else { return $0.0 }
                
                let hasDecimalPoint = inputString.contains(String.formatterDecimalAndCommas.decimalSeparator)
                if hasDecimalPoint {
                    let values = inputString.components(separatedBy: String.formatterDecimalAndCommas.decimalSeparator)
                    guard 1...2 ~=  values.count else {
                        return $0.0
                    }
                    return $0.1.commaWithDecimalsMinOneMaxTwo
//                    let wholeNumberPart = (values.first?.commaWithDecimals?.doubleValue ?? 0).removeDecimalIfEmpty
//                    return [wholeNumberPart as String?, values.last].compactMap { $0 }.joined(separator: String.formatterDecimalAndCommas.decimalSeparator)
                    
                } else {
                    return $0.1.removeDecimalIfEmpty
                }
            }
    }
}
