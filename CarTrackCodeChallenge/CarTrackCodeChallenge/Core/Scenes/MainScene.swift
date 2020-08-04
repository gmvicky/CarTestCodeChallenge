//
//  MainScene.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 1/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum MainScene: SceneVC {
    case details
    case map(MKAnnotation)
}


extension MainScene {
    static func loadScene(rootViewController: LoginViewController) {
        let router = Router(viewController: rootViewController)
        let viewModel = LoginViewModel(router: router, databaseManager: SqliteDatabaseManager.shared)
        
        rootViewController.viewModel = viewModel
    }
    
        func router() -> RouterProtocol {
            switch self {
            case .details:
                return detailViewController()
            case .map(let location):
                return mapViewController(location: location)
            }
        }
    
    // MARK: - Private
    
    private func detailViewController() -> RouterProtocol {
        guard let view = R.storyboard.main.detailViewController() else {
            fatalError(R.storyboard.main.detailViewController.identifier + " not found")
        }
        
        let router = Router(viewController: view)
        let viewMoel = DetailViewModel(router: router)
        view.viewModel = viewMoel
        return router
    }
    
    private func mapViewController(location: MKAnnotation) -> RouterProtocol {
        guard let view = R.storyboard.main.mapViewController() else {
            fatalError(R.storyboard.main.mapViewController.identifier + " not found")
        }
        
        let router = Router(viewController: view)
        let viewMoel = MapViewModel(router: router, location: location)
        view.viewModel = viewMoel
        return router
    }
}
