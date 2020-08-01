//
//  BaseViewModel.swift
//  xApp
//
//  Created by WT-iOS on 4/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit
import Action
import RxSwift
import SnapKit

protocol BaseViewModelProtocol {
    var router: RouterProtocol { get set }
    var onClose: CocoaAction { get }
    var disposeBag: DisposeBag { get }
    
    func initialLoad()
    func openToastMessage(_ message: String)
}

class BaseViewModel: NSObject, BaseViewModelProtocol {
    
    var router: RouterProtocol
    let disposeBag = DisposeBag()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    deinit {
        print("\(String(describing: self)) deinitialized")
    }
    
    func initialLoad() {
        
    }
    
    lazy var onClose: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let `self` = self else { return .empty() }
            return self.router.observableClose.execute(())
        }
    }()
    
    func openToastMessage(_ message: String) {
        guard let viewController = router.viewController else { return }
        guard let view = R.nib.bottomFadingPopupView.firstView(owner: nil) else { return
        }
        let viewModel = BottomFadingPopupViewModel()
        view.popupViewModel = viewModel
        viewModel.customMessage = message
        
        router.viewController?.view.endEditing(false)
        viewController.view.addSubview(view)
        view.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
