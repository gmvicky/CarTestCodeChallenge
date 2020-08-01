//
//  AlertTagStructure.swift
//  DinDinn
//
//  Created by DD_01 on 7/3/19.
//  Copyright © 2019 DinDinn. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol AlertStructureProtocol {
    var title: String? { get set }
    var message: String? { get set }
    var style: UIAlertController.Style { get }
    var tintColor: UIColor? { get }
    var options: [AlertOptionProtocol] { get }
}

enum AlertOptionType {
    case normalCell
    case radioButton
}

protocol AlertOptionProtocol  {

    var title: String? { get }
    var style: UIAlertAction.Style { get }
    var isEnabled: Bool { get }
    var isEnabledObservable: Observable<Bool>? { get }
    var alertOptionType: AlertOptionType { get }
    
    func customAction()
}

extension AlertOptionProtocol {
    
    var isEnabled: Bool { return true }
    
    func customAction() { }
    var alertOptionType: AlertOptionType { return .normalCell }
    var isEnabledObservable: Observable<Bool>? { return nil }
}

struct AlertOption: AlertOptionProtocol {
    
    
    var title: String?
    var style: UIAlertAction.Style
    
    func customAction() {
    }
}

struct AlertTagStructure: AlertStructureProtocol {
    

    static func genericError(error: Error, options: [AlertOptionProtocol] = []) -> AlertTagStructure {
        let alertOptions = options.count > 1 ? options :  [GenericAlertOption<()>.ok(nil, nil)]
        return AlertTagStructure(title: "Error",
                                 message: error.localizedDescription,
                                 style: .actionSheet,
                                 tintColor: .darkGray,
                                 options: alertOptions)
    }
    
    var title: String?
    var message: String?
    let style: UIAlertController.Style
    let tintColor: UIColor?
    let options: [AlertOptionProtocol]
    
    init(title: String? = nil,
         message: String? = nil,
         style: UIAlertController.Style = .actionSheet,
         tintColor: UIColor? = nil,
         options: [AlertOptionProtocol]) {
        self.title = title
        self.message = message
        self.style = style
        self.tintColor = tintColor
        self.options = options
    
    }
}

extension UIAlertController {
    
    static func present(in viewController: UIViewController,
                        alertStructure: AlertTagStructure) {
        let alertController = UIAlertController(title: alertStructure.title, message: alertStructure.message, preferredStyle: alertStructure.style)
        if let tint = alertStructure.tintColor {
            alertController.view.tintColor = tint
        }
        
        alertStructure.options.forEach { option in
            let action = UIAlertAction(title: option.title, style: option.style, handler: { _ in
                option.customAction()
            })
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}

protocol AlertSource: class {
    typealias alertsSource = ((AlertTagStructure?) -> ())
    
    var alerts: alertsSource? { get set }
}

protocol AlertViewControllerPresenterProtocol: class  {
 
    var alertRootViewController: UIViewController? { get }
    func observeAlerts(alerts: AlertSource?)
}

extension AlertViewControllerPresenterProtocol {
    
    func observeAlerts( alerts: AlertSource?) {
        alerts?.alerts = { [weak self] alertEvent in
            guard let `self` = self,
                let alert = alertEvent,
                let viewController = self.alertRootViewController else { return }
            DispatchQueue.main.async {
                UIAlertController.present(in: viewController, alertStructure: alert)
            }
        }
        
    }
}
