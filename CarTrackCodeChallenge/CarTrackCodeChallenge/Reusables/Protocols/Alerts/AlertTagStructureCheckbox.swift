//
//  AlertTagStructureCheckbox.swift
//  xApp
//
//  Created by WT-iOS on 13/1/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import RxSwift

class AlertTagStructureCheckbox: AlertStructureProtocol {
    
    var title: String?
    var message: String?
    let style: UIAlertController.Style
    let tintColor: UIColor?
    
    
    let alertToggledSubject: PublishSubject<AlertCheckBoxOption>
    let isSingleSelection: Bool
    let disposeBag = DisposeBag()
    let checkBoxOptions: [AlertCheckBoxOption]
    let otherOptions: [AlertOptionProtocol]
    
    var options: [AlertOptionProtocol] { return checkBoxOptions + otherOptions }
    
    init(alertToggledSubject: PublishSubject<AlertCheckBoxOption>,
         isSingleSelection: Bool = true,
         title: String? = nil,
         message: String? = nil,
         style: UIAlertController.Style = .actionSheet,
         tintColor: UIColor? = nil,
         checkBoxOptions: [AlertCheckBoxOption],
         otherOptions: [AlertOptionProtocol]) {
        self.title = title
        self.message = message
        self.style = style
        self.tintColor = tintColor
        self.alertToggledSubject = alertToggledSubject
        self.isSingleSelection = isSingleSelection
        self.checkBoxOptions = checkBoxOptions
        self.otherOptions = otherOptions
        
        if isSingleSelection {
            alertToggledSubject
                .subscribe(onNext: { checkBox in
                    self.checkBoxToggled(checkBox)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func checkBoxToggled(_ checkBox: AlertCheckBoxOption) {
        guard isSingleSelection else { return }
        
        checkBoxOptions.forEach {
            if checkBox.title != $0.title {
                $0.isSelectedRelay.accept(false)
            }
        }
        checkBox.isSelectedRelay.accept(!checkBox.isSelectedRelay.value)
    }
}
