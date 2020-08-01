//
//  UIButton+RxHighlighted.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {
    var isHighlighted: Observable<Bool> {
        let anyObservable = self.base.rx.methodInvoked(#selector(setter: self.base.isHighlighted))

        let boolObservable = anyObservable
            .flatMap { Observable.from(optional: $0.first as? Bool) }
            .startWith(self.base.isHighlighted)
            .distinctUntilChanged()
            .share()

        return boolObservable
    }
}
