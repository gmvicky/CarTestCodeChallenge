//
//  SwipeNavigationController.swift
//  Speshe
//
//  Created by WT-iOS on 4/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class SwipeNavigationController: UINavigationController {

    // MARK: - Lifecycle

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setup()
    }

    private func setup() {
        delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
    }

    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }

    // MARK: - Overrides

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true

        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - Private Properties

    fileprivate var duringPushAnimation = false
}


// MARK: - UINavigationControllerDelegate

extension SwipeNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }

        swipeNavigationController.duringPushAnimation = false
    }

}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}
