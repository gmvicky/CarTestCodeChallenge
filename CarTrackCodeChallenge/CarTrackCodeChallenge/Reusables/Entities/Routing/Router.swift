//
//  Router.swift
//  Routing
//
//  Created by Nikita Ermolenko on 29/09/2017.
//

import UIKit
import Action
import RxSwift

protocol Closable: class {
    func close()
    var observableClose: CocoaAction { get }
    var observableRootClose: CocoaAction { get }
}

protocol RouterProtocol: Closable {
    var viewController: UIViewController? { get set }
    var openTransition: Transition? { get set }
    
    func open(_ destinationRouter: RouterProtocol, transition: Transition)
    var observableOpen: Action<(RouterProtocol, Transition), Void> { get }
}

class Router: RouterProtocol {

    weak var viewController: UIViewController?
    var openTransition: Transition?
    
    private let viewControllerName: String
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
        viewControllerName = String(describing: viewController)
    }
    
    deinit {
        print("\(String(describing: self)) \(viewControllerName) deinitialized")
    }

    func open(_ destinationRouter: RouterProtocol, transition: Transition) {
        guard let viewController = destinationRouter.viewController else {
            assertionFailure("Nothing to transition.")
            return
        }
        transition.viewController = self.viewController
        destinationRouter.openTransition = transition
        transition.open(viewController)
    }

    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
        
    }
    
    lazy var observableClose: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let `self` = self else { return .empty() }

            guard let openTransition = self.openTransition else {
                assertionFailure("You should specify an open transition in order to close a module.")
                return .empty()
            }
            guard let viewController = self.viewController else {
                assertionFailure("Nothing to close.")
                return .empty()
            }

            let subject = PublishSubject<Void>()
            openTransition.close(viewController) {
                subject.onCompleted()
            }
            return subject
        }
    }()

    lazy var observableRootClose: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let `self` = self else { return .empty() }

            guard let openTransition = self.openTransition else {
                assertionFailure("You should specify an open transition in order to close a module.")
                return .empty()
            }
            guard let viewController = self.viewController else {
                assertionFailure("Nothing to close.")
                return .empty()
            }

            let subject = PublishSubject<Void>()
            openTransition.rootClose(viewController) {
                subject.onCompleted()
            }
            return subject
        }
    }()

    lazy var observableOpen: Action<(RouterProtocol, Transition), Void> = {
        return Action { [weak self] (destinationRouter, transition) in
            guard let `self` = self else { return .empty() }
            guard let viewController = destinationRouter.viewController else {
                assertionFailure("Nothing to transition.")
                return .empty()
            }
            transition.viewController = self.viewController
            destinationRouter.openTransition = transition

            let subject = PublishSubject<Void>()
            transition.open(viewController) {
                subject.onCompleted()
            }
            return subject
        }
    }()
}
