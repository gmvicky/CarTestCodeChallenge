//
//  PhoneEmailUsernameTexfieldView.swift
//  Speshe
//
//  Created by WT-iOS on 23/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import Combine
import RxSwift

enum LoginType {
    case username(String? = nil)
    case phone(String? = nil, AuthenticationModelProtocol? = nil)
    case email(String? = nil)
    
    var textValue: String? {
        switch self {
        case .username(let text), .phone(let text, _),
             .email(let text):
            return text
        }
    }
    
    var completeText: String? {
        switch self {
        case .phone(_,let auth):
            return auth?.completeMobileNumberDigitsOnly
        case .username(let text),
             .email(let text):
            return text
        }
    }
    
    var completeText2: String? {
        switch self {
        case .phone(_,let auth):
            return auth?.completeMobileNumber
        case .username(let text),
             .email(let text):
            return text
        }
    }
    
    func modifyText(_ text: String?) -> LoginType {
        switch self {
        case .username:
            return .username(text)
        case .email:
            return .email(text)
        case .phone(_, let auth):
            return .phone(text, auth)
        }
    }
    
    func formattedText() -> String? {
        switch self {
        case .username(let text), .email(let text):
            return text
        case .phone(_, let auth):
            return auth?.formattedLocalNumber()
        }
    }
    
    var paramName: String {
        switch self {
        case .username:
            return "username"
        case .email:
            return "email"
        case .phone:
            return "phone"
        }
    }
    
    
}

class PhoneEmailUsernameTextfieldView: UIView, ViewCoderLoadable {
    
    
    
    @IBOutlet weak var constraintFloatingMode: NSLayoutConstraint!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var constraintPlaceholderMode: NSLayoutConstraint!
    @IBOutlet weak var floatingPlaceholderLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var countryDialcode: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var constraintNonPhone: NSLayoutConstraint!
    @IBOutlet weak var constraintPhone: NSLayoutConstraint!
    @IBOutlet weak var textfield: UITextField!
    
    let textSubject = CurrentValueSubject<String?, Never>(nil)
    let selectCountrySubject = PassthroughSubject<(), Never>()
    
    var fixType: LoginType? = nil
    
    private let cancelBag = CancellableBag()
    private var textSubjectCancelBag = CancellableBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
        setupObservers()
    }
    
    var item: AuthenticationModelProtocol? {
        didSet { bindModel() }}
    
    var textItemType: AnyPublisher<LoginType, Never> {
        return textSubject
            .map { [weak self] in
                guard let text = $0 else {
                    if let auth = self?.item {
                        if case .phone = self?.fixType {
                            return .phone(auth.mobileNumber, auth)
                        }
                    }
                    return .username(nil)
                }
                
                let removedWhitespaces = text.removingWhitespaces()
                switch (text, removedWhitespaces) {
                case let (_, aText) where aText.isNumeric:
                    return .phone(aText, self?.item)
                case let (aText, _) where aText.isEmailFormatValid():
                    return .email(aText)
                default:
                    if let fix = self?.fixType {
                        return fix.modifyText(text)
                    }
                    return .username(text)
                }
            }
            .eraseToAnyPublisher()
    }
    

    func bind(to inputObject: InputObject, cancelBag: CancellableBag, viewControllerRootView: UIView? = nil) {
        textSubjectCancelBag = CancellableBag()
        
        textfield.bindText(to: inputObject.textSubject, formattedTextSubject: inputObject.formattedTextSubject, cancelBag: cancelBag)

        inputObject.textSubject
            .removeDuplicates()
            .sink(receiveValue: { [weak self] in self?.textSubject.send($0) })
            .add(to: cancelBag)
        
        
//        let error = inputObject.errors
//            .map { $0.last?.errorType.errorDescription }
//            .eraseToAnyPublisher()
//
//        errorLabel.bindText(to: error, cancelBag: cancelBag, viewControllerRootView: viewControllerRootView)
    }
    
    func setLoginType(_ loginType: LoginType) {
       
        switch loginType {
        case .username(let text), .email(let text):
            self.textSubject.send(text)
        case let .phone(_, auth):
            self.item = auth
            let text = auth?.formattedLocalNumber()
            textfield.text = text
            self.textSubject.send(text)
            
        }
        self.floatingMode()
        dropdownView.isHidden = true
        
//         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//           DispatchQueue.main.async { [weak self] in
//               switch loginType {
//               case .username(let text), .email(let text):
//                   self?.textSubject.send(text)
//               case let .phone(text, auth):
//                   self?.textSubject.send(text)
//                   self?.item = auth
//               }
//               self?.floatingMode()
//           }
//       }
    }
    
    // MARK: - Private
    
    private func bindModel() {
        flagImageView.image = item?.countryInfo?.flag
//        textSubject.send(item?.mobileNumber)
//        textfield.text = item?.mobileNumber
        countryDialcode.text = item?.countryInfo?.dialCode
    }
    
    private func setupObservers() {
        textfield.bindText(to: textSubject, cancelBag: textSubjectCancelBag)
        
        NotificationCenter.default
        .publisher(for: UITextField.textDidChangeNotification, object: textfield)
            .sink(receiveValue: { [weak self] in
                self?.textSubject.send(($0.object as? UITextField)?.text?.trimmed) })
        .add(to: textSubjectCancelBag)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: textfield)
            .sink(receiveValue: { [weak self] in
                if let aTextField = $0.object as? UITextField,
                    aTextField.text?.isEmpty ?? true {
                    self?.floatingMode()
                }
            })
            .add(to: cancelBag)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidEndEditingNotification, object: textfield)
            .sink(receiveValue: { [weak self] in
                if let aTextField = $0.object as? UITextField,
//                    aTextField ==  self?.textfield,
                    aTextField.text?.isEmpty ?? true {
                    if case .phone = self?.fixType {
                        return 
                    }
                    self?.placeHolderMode()
                }
            })
            .add(to: cancelBag)
        
        textItemType
            .map { type -> Bool in
                if case .phone = type { return true }
                return false
            }
            .removeDuplicates()
            .sink { [weak self] in
                guard let `self` = self else { return }
                 
                if self.fixType == nil {
                    self.phoneView
                    .fadeInOrOutAutomatic(withContainerView: self, shouldShow: $0)
                } else {
                    self.phoneView.isHidden = false
                }
                
                let config = $0 ? (self.constraintNonPhone, self.constraintPhone) : (self.constraintPhone, self.constraintNonPhone)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    config.0?.priority = .defaultLow
                    config.1?.priority = .defaultHigh
                    self?.layoutIfNeeded()
                    self?.setNeedsLayout()
                    
                }, completion: nil)
            }
            .add(to: cancelBag)
        
        
        phoneButton.action.sink(receiveValue: { [weak self] _ in
                self?.selectCountrySubject.send(())
            })
            .add(to: cancelBag)
    }
    
    private func placeHolderMode() {
        UIView.animate(withDuration: 0.3) {
            self.constraintFloatingMode.priority = .defaultLow
            self.constraintPlaceholderMode.priority = .defaultHigh
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    private func floatingMode() {
        
        UIView.animate(withDuration: 0.3) {
            self.constraintPlaceholderMode.priority = .defaultLow
            self.constraintFloatingMode.priority = .defaultHigh
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
}
