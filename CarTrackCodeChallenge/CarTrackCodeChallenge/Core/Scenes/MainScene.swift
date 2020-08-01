//
//  MainScene.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 1/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import UIKit

enum MainScene: SceneVC {
    case details
}


extension MainScene {
//    static func loadScene(rootViewController: RootViewController) {
//        let viewModel = RootViewModel()
//        viewModel.userManager = UserManager.shared
//        viewModel.rootManager = RootManager.shared
//        rootViewController.rootViewModel = viewModel
//    }
    
        func router() -> RouterProtocol {
    //        guard let view = R.storyboard.root.rootViewController() else {
    //            fatalError(R.storyboard.root.rootViewController.identifier + " not found")
    //        }
    //        Root.loadScene(rootViewController: view)
    //        return view
            return Router(viewController: nil)
        }
}
