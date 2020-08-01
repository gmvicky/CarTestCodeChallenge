//
//  PushTransition.swift
//  Routing
//
//  Created by Nikita Ermolenko on 28/10/2017.
//

import UIKit

class PushTransition: NSObject {

    var animator: Animator?
    var isAnimated: Bool = true
    var completionHandler: (() -> Void)?

    weak var viewController: UIViewController?

    init(animator: Animator? = nil, isAnimated: Bool = true) {
        self.animator = animator
        self.isAnimated = isAnimated
    }
    
    deinit {
        print("\(String(describing: self)) deinitialized")
    }
}

// MARK: - Transition

extension PushTransition: Transition {
    
    func open(_ viewController: UIViewController, completionHandler: (() -> Void)? = nil) {
        self.completionHandler = completionHandler
        
        let navigationController = self.viewController?.navigationController ?? self.viewController as? UINavigationController
        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    func close(_ viewController: UIViewController, completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
        
        let navigationController = self.viewController?.navigationController ?? self.viewController as? UINavigationController
        navigationController?.delegate = self
        navigationController?.popViewController(animated: isAnimated)
    }
    
    func rootClose(_ viewController: UIViewController, completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
        let navigationController = self.viewController?.navigationController ?? self.viewController as? UINavigationController
        navigationController?.delegate = self
        navigationController?.popToRootViewController(animated: isAnimated)
        
    }
}

// MARK: - UINavigationControllerDelegate

extension PushTransition: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        completionHandler?()
        completionHandler = nil
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            animator.isPresenting = false
            return animator
        }
    }
}
