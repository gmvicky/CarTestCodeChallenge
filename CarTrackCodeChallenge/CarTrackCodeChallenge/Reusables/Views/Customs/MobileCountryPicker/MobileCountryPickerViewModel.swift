//
//  MobileCountryPickerViewModel.swift
//  xApp
//
//  Created by WT-iOS on 22/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import Action
import PhoneNumberKit

protocol MobileCountryPickerViewModelProtocol: BaseViewModelProtocol {
    var onCountrySelected: Action<(String, String),Void>? { get }
}

class MobileCountryPickerViewModel: BaseViewModel, MobileCountryPickerViewModelProtocol {
    
    weak var onCountrySelected: Action<(String, String),Void>?
    private let phoneNumberKit = PhoneNumberKit()
    
    init( onCountrySelected: Action<(String, String),Void>) {
        self.onCountrySelected = onCountrySelected
        //super.init(router: router)
    }
    
//    required init(router: RouterProtocol) {
//        fatalError("init(router:) has not been implemented")
//    }
}

