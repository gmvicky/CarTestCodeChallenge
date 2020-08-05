//
//  LoginViewModel.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxOptional

protocol LoginViewModelProtocol: BaseViewModelProtocol, CountryCodePickerPresenter {
    
    var selectedCountry: Observable<CountryCodePickerViewController.Country?> { get }
    var canProceed: Observable<Bool> { get }
    
    var userNameRelay: BehaviorRelay<String?> { get }
    var passwordRelay: BehaviorRelay<String?> { get }
    
    var onSelectCountry: CocoaAction { get }
    var onLogin: CocoaAction { get }
}

class LoginViewModel: BaseViewModel, LoginViewModelProtocol {
    
    var picker: CountryCodePickerViewController?
    
    var selectedCountry: Observable<CountryCodePickerViewController.Country?> { return countryRelay.asObservable() }
    
    let userNameRelay = BehaviorRelay<String?>(value: nil)
    let passwordRelay = BehaviorRelay<String?>(value: nil)
    
    private let countryRelay = BehaviorRelay<CountryCodePickerViewController.Country?>(value: nil)
    
    private let databaseManager: UserDatabaseManagerProtocol
    
    init(router: RouterProtocol,
         databaseManager: UserDatabaseManagerProtocol) {
        self.databaseManager = databaseManager
        super.init(router: router)
    }
    
    override func initialLoad() {
        databaseManager.dbStatus
            .take(1)
            .subscribe(onNext: { [weak self] in
                if case .failure(let error) = $0 {
                    self?.openToastMessage(error.errorDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    lazy var onSelectCountry: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let `self` = self, let nav = self.router.viewController?.navigationController else { return .empty() }
            self.onShowCountryPicker(rootNavigationController: nav)
            return .empty()
        }
    }()
    
    var canProceed: Observable<Bool> {
        return Observable.combineLatest(countryRelay, userNameRelay, passwordRelay)
            .map { $0.0 != nil && ($0.1?.isNotEmpty ?? false) && ($0.2?.isNotEmpty ?? false) }
        
    }
    
    lazy var onLogin: CocoaAction = {
        return CocoaAction(enabledIf: canProceed) { [weak self] in
            
            guard let databaseManager = self?.databaseManager, let userName = self?.userNameRelay.value, let password = self?.passwordRelay.value else { return .empty() }
            
            let result = databaseManager.checkLogin(userName: userName, password: password)
            
            switch result {
            case .success:
                let destination = MainScene.details.router()
                self?.router.open(destination, transition: PushTransition())
            case .failure(let error):
                self?.openToastMessage(error.errorDescription)
            }
            
            return .empty()
        }
    }()
    
    // MARK: - CountryCodePickerPresenter
    
    var shouldShowPhone: Bool { return false }
    
    lazy var onCountrySelected: Action<CountryCodePickerViewController.Country, Void> = {
        return Action { [weak self] in
            self?.countryRelay.accept($0)
            return .empty()
        }
    }()
    
    func countryCodePickerViewControllerDidPickCountry(_ country: CountryCodePickerViewController.Country) {
        onCountryCodePickerViewControllerDidPickCountry(country)
    }
}
