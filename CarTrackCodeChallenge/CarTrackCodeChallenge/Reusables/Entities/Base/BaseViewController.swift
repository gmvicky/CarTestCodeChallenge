//
//  BaseViewController.swift
//  xApp
//
//  Created by WT-iOS on 4/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController<T>: UIViewController where T: BaseViewModelProtocol {
    
    enum PersistenceType {
        case defaultType
        case persistent
    }
    
    var viewModel: T?
    var persistenceType = PersistenceType.defaultType
    
    /**
     Dismiss keyboard when viewcontroller's view is tapped if set to true true.
     */
    var shouldDismissKeyboardWhenViewIsTapped: Bool { return false }
    /**
     Specifies the excluded view types form dismissing the keyboard when shouldDismissKeyboardWhenViewIsTapped is set to true.
     Defaults are UIButton, UITextField, UITextView.
     */
    var excludedViewTypesFromDismissingKeyboard: [UIView.Type]? {
        return nil
    }
    
    var keyboardAdjuster: KeyboardVisibleAdjusterProtocol? { return nil }
    
    var shouldPopToRoot: Bool { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.initialLoad()
        setUpGestureRecognizers()
        observeKeyboardHeightChanges()
        configureViews()
        bindViewModel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(self.description) deinitialized")
    }
    
    func configureViews() { }
    func bindViewModel() { }
    
    // MARK: - TapGesture
    
    private func setUpGestureRecognizers() {
        guard shouldDismissKeyboardWhenViewIsTapped else { return }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewIsTapped(gesture:)))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func viewIsTapped(gesture: UITapGestureRecognizer) {
        
        let view = gesture.view
        let loc = gesture.location(in: view)
        if let subview = view?.hitTest(loc, with: nil) {
            var excludedControlTypes: [UIView.Type] = [UIButton.self, UITextView.self, UITextField.self]
            if let controlTypes = excludedViewTypesFromDismissingKeyboard {
                excludedControlTypes.append(contentsOf: controlTypes)
            }
            
            
            if !subview.containsViews(withTypes: excludedControlTypes) {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.endEditing(false)
                    self?.navigationController?.view.endEditing(true)
                }
            }
        }
    }
    
    private func isViewExcludedFromTouch(_ touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return true }
        var excludedControlTypes: [UIView.Type] = [UIButton.self, UITextView.self, UITextField.self]
        if let controlTypes = excludedViewTypesFromDismissingKeyboard {
            excludedControlTypes.append(contentsOf: controlTypes)
        }
        return touchView.containsViews(withTypes: excludedControlTypes)
    }
    
    // MARK: - Keyboard
    
    private func observeKeyboardHeightChanges() {
        
        guard keyboardAdjuster != nil else { return }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            updateHeight(offset: keyboardRectangle.height)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let _: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            updateHeight(offset: .zero)
        }
    }
    
    private func updateHeight(offset: CGFloat) {
        var keyboardFocusRect: CGRect? = nil
        if let sourceView = UIResponder.currentFirst() as? UIView {
            keyboardFocusRect = sourceView.convert(sourceView.frame, to: view)
        }
        keyboardAdjuster?.updateComponent(offset, keyboardFocusRect: keyboardFocusRect)
    }
    
    // MARK: - Navigation
    
    func shouldHideNavigationBarShadow(shouldShowBarShadow: Bool) {
            navigationController?.navigationBar.setValue(!shouldShowBarShadow, forKey: "hidesShadow")
            
            if let layer = navigationController?.navigationBar.layer {
                if shouldShowBarShadow {
                    layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
                    layer.shadowOffset = CGSize(width: 0, height: 1)
                    layer.shadowRadius = 2
                    layer.shadowOpacity = 0.7
                    layer.masksToBounds = false
                    navigationController?.navigationBar.shadowImage = nil
                    
                } else {
                    layer.shadowOpacity = 0.0
                    navigationController?.navigationBar.shadowImage = UIImage()
                }
            }
            
        }
        
        func transparentNavigationBar() {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navigationController?.navigationBar.layer.shadowOpacity = 0.0
            self.navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        
        func clearNavigationBarBackground(shouldShowBarShadow: Bool = false) {
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.setBackgroundImage( nil, for: .default)
            shouldHideNavigationBarShadow(shouldShowBarShadow: shouldShowBarShadow)
        }
        
    func setupNavigationItemLeftBarButtonImage(_ image: UIImage? = R.image.backArrow()) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action:  #selector(leftBarButtonTapped(_:)))
            
        }
    
        @objc func leftBarButtonTapped(_ sender: UIBarButtonItem)
        {
            if shouldPopToRoot {
                navigationController?.popToRootViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
            
        }
}
