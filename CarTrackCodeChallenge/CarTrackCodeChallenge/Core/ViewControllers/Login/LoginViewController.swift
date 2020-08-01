//
//  LoginViewController.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController<LoginViewModel> {
    
    private struct Constants {
        static let userNamePlaceholder = "User Name"
        static let passwordPlaceholder = "Password"
        static let selectCountryTitle = "Select Country"
    }
    
    @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
    @IBOutlet weak var userNameTextfield: FloatingPlaceholderTextfieldView!
    @IBOutlet weak var passwordTextfield: FloatingPasswordPlaceholderTextView!
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var selectCountryArrowImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override var shouldDismissKeyboardWhenViewIsTapped: Bool { return true }
    
    override var keyboardAdjuster: KeyboardVisibleAdjusterProtocol? { return keyboardAdjusterModel}
    
    private lazy var keyboardAdjusterModel: KeyboardVisibleAdjusterProtocol = {
        return KeyboardVisibileAdjustCenterConstraint(centerConstraint: constraintCenterY, superView: view, customMultiplier: -50)
    }()
    
    override func viewDidLoad() {
        MainScene.loadScene(rootViewController: self)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func configureViews() {
        userNameTextfield.titleLabel.text = Constants.userNamePlaceholder
        passwordTextfield.titleLabel.text = Constants.passwordPlaceholder
        
        selectCountryButton.rx.isHighlighted
              .map { $0 ? .lightGray : .black}
              .subscribe(onNext: { [weak self] in
                  self?.selectCountryArrowImageView.tintColor = $0
              })
              .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        userNameTextfield.textfield.bindText(to: viewModel.userNameRelay, disposeBag: rx.disposeBag)
        passwordTextfield.textfield.bindText(to: viewModel.passwordRelay, disposeBag: rx.disposeBag)
        
        selectCountryButton.rx.action = viewModel.onSelectCountry
        loginButton.rx.action = viewModel.onLogin
        
        viewModel.selectedCountry
            .map {
                guard let country = $0 else { return Constants.selectCountryTitle }
                return "\(country.flag) \(country.name)"
            }
            .asDriver(onErrorJustReturn: Constants.selectCountryTitle)
            .drive(selectCountryButton.rx.title(for: .normal))
            .disposed(by: rx.disposeBag)
        
        viewModel.canProceed
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabledColor)
            .disposed(by: rx.disposeBag)
    }
}
