//
//  UILabel+combineBind.swift
//  PrivatePod4
//
//  Created by WT-iOS on 21/2/20.
//

import UIKit
import Combine
import RxSwift

extension UILabel {
    
    func bindText(to text: Observable<String?>, disposeBag: DisposeBag, viewControllerRootView: UIView? = nil) {
    
        text
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                let shouldAnimateConstraints: Bool
                if (value?.isEmpty ?? true) && !(self?.text?.isEmpty ?? true) {
                    shouldAnimateConstraints = true
                } else if !(value?.isEmpty ?? true) && (self?.text?.isEmpty ?? true) {
                    shouldAnimateConstraints = true
                } else {
                    shouldAnimateConstraints = false
                }
                self?.text = value
                if shouldAnimateConstraints {
                    self?.setNeedsUpdateConstraints()
                    UIView.animate(withDuration: 0.1) { [weak self] in
                        (viewControllerRootView ?? self?.superview)?.layoutIfNeeded()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func bindText(to text: AnyPublisher<String?, Never>, cancelBag: CancellableBag, viewControllerRootView: UIView? = nil) {
    
        text
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                let shouldAnimateConstraints: Bool
                if (value?.isEmpty ?? true) && !(self?.text?.isEmpty ?? true) {
                    shouldAnimateConstraints = true
                } else if !(value?.isEmpty ?? true) && (self?.text?.isEmpty ?? true) {
                    shouldAnimateConstraints = true
                } else {
                    shouldAnimateConstraints = false
                }
                self?.text = value
                if shouldAnimateConstraints {
                    self?.setNeedsUpdateConstraints()
                    UIView.animate(withDuration: 0.1) { [weak self] in
                        (viewControllerRootView ?? self?.superview)?.layoutIfNeeded()
                    }
                }
                
            }
            .add(to: cancelBag)
    }
    
}
