//
//  MobileCountryPickerViewController.swift
//  xApp
//
//  Created by WT-iOS on 22/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import PhoneNumberKit

class MobileCountryPickerViewController: BaseViewController {
    
    var viewModel : MobileCountryPickerViewModelProtocol?
    override var baseViewModel: BaseViewModelProtocol? { return viewModel }
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    let phoneNumberKit: PhoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPicker()
    }
    
    
    // MARK: - Private
    
    private func loadPicker() {
//        let picker = CountryCodePickerViewController(phoneNumberKit: phoneNumberKit)
//        let nav = UINavigationController(rootViewController: picker)
//
//        pickerView.addSubview(nav.view)
//        nav.view.snp.makeConstraints { maker in
//            maker.edges.equalToSuperview()
//        }
//        addChild(nav)
//        nav.didMove(toParent: parent)
        
//        CountryPickerView(frame: view.bounds)
//        picker.delegate = viewModel
//        picker.dataSource = viewModel
        
        //        picker.hidesNavigationBarWhenPresentingSearch = false
//        addChild(picker)
//        picker.didMove(toParent: parent)
//        picker.didSelectCountryWithCallingCodeClosure = { [weak self] _, code, dialCode in
////            self?.mobileVerificationViewModel?.countryAndDialCode = (code, dialCode)
//            self?.viewModel?.onCountrySelected?.execute((code, dialCode))
//            self?.viewModel?.router.close()
//
//        }
    }
    
    private func bindViewModel() {
        //closeButton.rx.action = viewModel?.onClose
    }
}
