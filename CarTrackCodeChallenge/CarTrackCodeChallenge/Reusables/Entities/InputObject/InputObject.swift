//
//  InputObject.swift
//  Speshe
//
//  Created by WT-iOS on 24/1/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class InputObject {
    var textRelay = BehaviorRelay<String?>(value: nil)
    
    private let errorChecks: [InputError.ErrorType]
    var formatterRelay = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init(errorChecks: [InputError.ErrorType] = []) {
        self.errorChecks = errorChecks

        for item in errorChecks {
            if case .notMatching(let inputObject) = item {
                observeMatch(inputObject: inputObject)
                break
            }
        }
        
    }
    
    func setFormattedText(formatted: Observable<String?>) {
        let aFormattedTextSubject = BehaviorRelay<String?>(value: nil)
        formatterRelay = aFormattedTextSubject
        
        formatted
            .bind(to: formatterRelay)
            .disposed(by: disposeBag)
    }
    
    var canProceed: Observable<Bool> {
        return errors
            .map { $0.isEmpty }
    }
    
    var errors: Observable<[InputError]> {
        return textRelay
            .map { [weak self] text in
                guard let `self` = self else { return [] }
                var allErrors = [InputError]()
                
                for errorType in self.errorChecks {
                    switch (errorType, self.textRelay.value) {
                    
                    case (.empty(let flag), .none):
                        allErrors.append(InputError(errorType: .empty(shouldShowWhenEmpty: flag)))
                    case  (.empty(let flag), .some(let aText)) where aText.isEmpty:
                        allErrors.append(InputError(errorType: .empty(shouldShowWhenEmpty: flag)))
                    case let (.insufficientNumberOfCharacters(count), .some(aText)) where count > aText.count && !aText.isEmpty:
                        allErrors.append(InputError(errorType:
                            .insufficientNumberOfCharacters(count)))
                    case let (.notMatching(inputObject), .some(aText)) where inputObject.textRelay.value != aText && !aText.isEmpty:
                        allErrors.append(InputError(errorType:
                        .notMatching(inputObject)))
                    case let (.passwordCombinationError, .some(aText)) where !aText.arePasswordCharacters2:
                        allErrors.append(InputError(errorType: .passwordCombinationError))
                    case let (.emailFormatNotValid, .some(aText)) where !aText.isEmailFormatValid():
                        allErrors.append(InputError(errorType: .emailFormatNotValid))
                    default:
                        break
                    }
                }
                return allErrors
            }
    }
    
    // MARK: - Private
    
    private func observeMatch(inputObject: InputObject) {
        inputObject.textRelay
            .subscribe(onNext: { [weak self] _ in
                self?.textRelay.accept(self?.textRelay.value)
            })
            .disposed(by: disposeBag)
    }
    
}
