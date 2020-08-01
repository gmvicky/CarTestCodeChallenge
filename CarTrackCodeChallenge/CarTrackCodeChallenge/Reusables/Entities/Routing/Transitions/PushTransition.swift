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
    
    var duringPushAnimation = false
    private let canSwipeBack: Bool

    init(animator: Animator? = nil, isAnimated: Bool = true,
         canSwipeBack: Bool = true) {
        self.animator = animator
        self.isAnimated = isAnimated
        self.canSwipeBack = canSwipeBack
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
        if canSwipeBack {
            
            navigationController?
            .interactivePopGestureRecognizer?.delegate = self
            navigationController?
            .interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController?
                .interactivePopGestureRecognizer?.isEnabled = false
        }
        navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    func close(_ viewController: UIViewController, completionHandler: (() -> Void)?) {
        self.completionHandler = completionHandler
        
        let navigationController = self.viewController?.navigationController ?? self.viewController as? UINavigationController ?? viewController.navigationController
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
        
        duringPushAnimation = false
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

// MARK: - UIGestureRecognizerDelegate

extension PushTransition: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == viewController?.navigationController?.interactivePopGestureRecognizer else {
            return true // default value
        }

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return (viewController?.navigationController?.viewControllers.count ?? 0) > 1 && duringPushAnimation == false
    }
}
