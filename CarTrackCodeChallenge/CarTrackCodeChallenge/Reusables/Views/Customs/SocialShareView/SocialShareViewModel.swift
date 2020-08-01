//
//  SocialShareViewModel.swift
//  Speshe
//
//  Created by WT-iOS on 22/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SocialShareViewModelProtocol: BaseViewModelProtocol {
    var onShowShareOptions: CocoaAction { get }
}

class SocialShareViewModel: BaseViewModel, SocialShareViewModelProtocol {
    
    enum ShareOptionType {
        case copy
        case activityViewController
    }
    
    private let items: Observable<[AnyObject]>
    
    init(items: Observable<[AnyObject]>,
         router: RouterProtocol) {
        self.items = items
        super.init(router: router)
    }
    
    lazy var onShowShareOptions: CocoaAction = {
        return showShareOptions()
    }()
    
    // MARK: - Privatee
    
    private func showShareOptions() -> CocoaAction {
        return CocoaAction { [weak self] in
            guard let `self` = self,
                let viewController = self.router.viewController else { return .empty() }
//            let options: [AlertOptionProtocol] = [AlertTableOption<ShareOptionType>(title: ShareOptionType.copy.title, customValue: .copy, action: self.onShareOptionSelected, isEnabled: true, style: .default), AlertTableOption<ShareOptionType>(title: ShareOptionType.activityViewController.title, customValue: .activityViewController, action: self.onShareOptionSelected, isEnabled: true, style: .default), GenericAlertOption.cancel((), nil)]
//
//            let alert = AlertTagStructure(title: "Share Options", style: .actionSheet, tintColor: .lightGray, options: options)
//
//            let destination = UtilsScene.alertTableView(alert).router()
//            self.router.open(destination, transition: ModalTransition())
            
            self.items
                .take(1)
                .asDriver(onErrorJustReturn: [])
                .drive(onNext: {
                    guard $0.isNotEmpty else { return }
                    ShareExternalActivity.share(items: $0, parentViewController: viewController)
                })
                .disposed(by: self.disposeBag)
            
            return .empty()
        }
    }
    
    private lazy var onShareOptionSelected: Action<ShareOptionType?, Void>? = {
        return Action { option in
            return .empty()
        }
    }()
}

extension SocialShareViewModel.ShareOptionType {
    var title: String {
        switch self {
        case .copy: return "Copy"
        case .activityViewController: return "Share"
        }
    }
}
