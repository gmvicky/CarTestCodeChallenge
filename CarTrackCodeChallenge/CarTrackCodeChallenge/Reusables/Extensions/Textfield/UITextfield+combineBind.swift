//
//  UITextfield+combineBind.swift
//  SpesheSDKTestConsumer
//
//  Created by WT-iOS on 18/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import Combine

class TextClasst {
    var aString: String?
}

extension UITextField  {
    
    public func bindText(to textSubject: CurrentValueSubject<String?, Never>, formattedTextSubject: AnyPublisher<String?, Never>? = nil, cancelBag: CancellableBag) {
        
        (formattedTextSubject ?? textSubject.eraseToAnyPublisher())
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
            self?.setPreservingCursor()(value)
        }
        .add(to: cancelBag)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .sink(receiveValue: { textSubject.send(($0.object as? UITextField)?.text) })
            .add(to: cancelBag)
    }
    
    func setPreservingCursor() -> (_ newText: String?) -> Void {
        return { [weak self] aNewText in
              guard let `self` = self else { return }
              guard let newText = aNewText else {
                  self.text = aNewText
                  return
              }
            
            let textField = self
            if let textRange = textField.selectedTextRange {
                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: textRange.start) + newText.count - (textField.text?.count ?? 0)
                textField.text = newText
                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
            }
        }
    }
}
