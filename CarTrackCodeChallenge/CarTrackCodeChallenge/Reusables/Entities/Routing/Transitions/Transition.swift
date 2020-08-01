//
//  Transition.swift
//  Routing
//
//  Created by Nikita Ermolenko on 29/09/2017.
//

import Foundation
import UIKit

protocol Transition: class {
    var viewController: UIViewController? { get set }

    func open(_ viewController: UIViewController, completionHandler: (() -> Void)?)
    func close(_ viewController: UIViewController, completionHandler: (() -> Void)?)
    func rootClose(_ viewController: UIViewController, completionHandler: (() -> Void)?)
}

extension Transition {
    func open(_ viewController: UIViewController, completionHandler: (() -> Void)? = nil) {
        open(viewController, completionHandler: completionHandler)
    }
    
    func close(_ viewController: UIViewController, completionHandler: (() -> Void)? = nil) {
        close(viewController, completionHandler: completionHandler)
    }
    
    func rootClose(_ viewController: UIViewController, completionHandler: (() -> Void)? = nil) {
        rootClose(viewController, completionHandler: completionHandler)
    }
}
