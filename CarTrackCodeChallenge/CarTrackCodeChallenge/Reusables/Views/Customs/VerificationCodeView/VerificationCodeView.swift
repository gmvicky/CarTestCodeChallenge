//
//  VerificationCodeView.swift
//  DinDinn
//
//  Created by DD_01 on 8/4/19.
//  Copyright © 2019 DinDinn. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class VerificationCodeView: UIView, ViewCoderLoadable {
    
    typealias verificationCodeClosure = ((String) -> ())
    
    @IBOutlet weak var stackView: UIStackView!
    
    var verificationCode: verificationCodeClosure?
    var isSecureTextEntry = true
    
    @IBInspectable
    public var numberOfCharacters: Int = 0 {
        didSet {
            if numberOfCharacters > 0 {
                populateStackView()
            }
        }
    }
    
    private var entryInputViews = [VerificationCodeInputView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var canSubmitCode: Bool {
        return entryInputViews.contains(where: { ($0.inputLabel.text ?? String()).isEmpty })
    }
    
    func resetEntry() {
        entryInputViews.forEach { $0.reset() }
        updateVerificationCode()
    }
    
    // MARK: - Private
    
    private func commonInit() {
        setUpLoadableView()
        populateStackView()
        setUpGesture()
    }
    
    var parsedInput: String {
        return entryInputViews.map { $0.getValue }.compactMap { $0 }.joined()
    }

    
    private func populateStackView() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        for _ in 0..<numberOfCharacters {
            if let entryInputView = entryInputView() {
                stackView.addArrangedSubview(entryInputView)
                entryInputView.isSecureTextEntry = isSecureTextEntry
            }
        }
        entryInputViews = stackView.arrangedSubviews.compactMap { $0 as? VerificationCodeInputView }
    }
    
    private func setUpGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
    }
    
    
    private func entryInputView() -> VerificationCodeInputView? {
        return R.nib.verificationCodeInputView(owner: nil)
    }
    
    private func updateVerificationCode() {
        verificationCode?(parsedInput)
    }
}

extension VerificationCodeView: UIKeyInput {
    
    var hasText: Bool {
        return entryInputViews.contains(where: { ($0.inputLabel.text?.isEmpty ?? true) == false })
    }
    
    func insertText(_ text: String) {
        if let emptyInputView = entryInputViews.first(where: { $0.inputLabel.text?.isEmpty ?? true }),
            !text.trimmed.isEmpty {
            emptyInputView.setText(text)
            updateVerificationCode()
        }
    }
    
    func deleteBackward() {
        if let populatedInputView = entryInputViews.reversed().first(where: { $0.inputLabel.text?.isEmpty == false }) {
            populatedInputView.deleteText()
            updateVerificationCode()
        }
    }
}

extension VerificationCodeView: UITextInputTraits {
    public var keyboardType: UIKeyboardType {
        get {
            return .numberPad
        }
        set {
            
        }
    }
}
