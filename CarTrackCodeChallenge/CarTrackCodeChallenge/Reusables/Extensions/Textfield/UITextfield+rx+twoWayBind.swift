//
//  UITextfield+rx.swift
//  xApp
//
//  Created by WT-iOS on 5/12/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//


import RxSwift
import RxCocoa
import Combine

extension UITextField  {
    
    func bindText(to textRelay: BehaviorRelay<String?>, disposeBag: DisposeBag) {
        
        textRelay
            .asDriver()
            .drive(onNext: setPreservingCursor())
            .disposed(by: disposeBag)
        
        rx.text
            .bind(to: textRelay)
            .disposed(by: disposeBag)
    }
    
//    func setPreservingCursor() -> (_ newText: String?) -> Void {
//        return { [weak self] aNewText in
//            guard let `self` = self else { return }
//            guard let newText = aNewText else {
//                self.text = aNewText
//                return
//            }
//            
//            let textField = self
//            if let textRange = textField.selectedTextRange {
//                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: textRange.start) + newText.count - (textField.text?.count ?? 0)
//                textField.text = newText
//                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
//                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
//                }
//            }
//        }
//    }
}

extension UITextView {
    func bindText(to textRelay: BehaviorRelay<String?>, disposeBag: DisposeBag) {
        
        textRelay
            .asDriver()
            .drive(rx.text)
            .disposed(by: disposeBag)
        
        rx.text
            .bind(to: textRelay)
            .disposed(by: disposeBag)
    }
}

extension UISearchBar {
    func bindText(to textRelay: BehaviorRelay<String?>, disposeBag: DisposeBag) {
        
        textRelay
            .asDriver()
            .drive(rx.text)
            .disposed(by: disposeBag)
        
        rx.text
            .bind(to: textRelay)
            .disposed(by: disposeBag)
    }
}
