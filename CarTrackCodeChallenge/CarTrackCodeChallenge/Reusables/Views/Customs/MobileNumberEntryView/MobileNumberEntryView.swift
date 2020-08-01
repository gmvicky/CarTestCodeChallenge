//
//  MobileNumberEntryView.swift
//  FrontRow
//
//  Created by WT-iOS on 5/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit
import Action

enum MobileNumberEntryViewAction {
    case selectCountry
    case editText(String?, Bool)
}

class MobileNumberEntryView: UIView, ViewCoderLoadable {
    
    var item: AuthenticationModelProtocol? {
        didSet { bindModel() }}
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var mobileEntryTextfield: UITextField!
    @IBOutlet weak var dialCodeLabel: UILabel!
    
    var mobileNumberAction: Action<MobileNumberEntryViewAction, Void>?
    var textFont = UIFont.systemFont(ofSize: 17)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    //  MARK: - IBActions
    @IBAction func selectCountryAction(_ sender: Any) {
        mobileNumberAction?.execute(.selectCountry)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        mobileNumberAction?.execute(.editText(sender.text, false))
    }
    
    @IBAction func textFieldEditBegan(_ sender: UITextField) {
        mobileNumberAction?.execute(.editText(sender.text, false))
    }
    
    @IBAction func textFieldEditEnd(_ sender: UITextField) {
        mobileNumberAction?.execute(.editText(sender.text, true))
    }
    // MARK: - Private
    
    private func commonInit() {
        setUpLoadableView()
        mobileEntryTextfield.font = textFont
    }
    
    
    private func bindModel() {
        flagImageView.image = item?.countryInfo?.flag
        mobileEntryTextfield.text = item?.mobileNumber
        dialCodeLabel.text = item?.countryInfo?.dialCode
    }
}
