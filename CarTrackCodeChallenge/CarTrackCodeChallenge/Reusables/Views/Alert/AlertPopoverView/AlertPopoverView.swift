//
//  AlertPopoverView.swift
//  Speshe
//
//  Created by WT-iOS on 30/5/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import UIKit

class AlertPopoverView: UIView {
    
    @IBOutlet weak var visualEffectView: VisualEffectBackgroundButtonView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableCenter: NSLayoutConstraint!
    
    var viewModel: AlertPopoverViewModelProtocol? {
        didSet { bindViewModel() }
    }
    
    
    override func layoutSubviews() {
           super.layoutSubviews()
           tableView.curveAllCorners(withRadius: 16.0)
       }
    
       private func bindViewModel() {
        guard let viewModel = viewModel else { return }
           viewModel.configureTableView(tableView)
           visualEffectView.backgroundButton.rx.action = viewModel.onClose
           
           tableView.rx.observeWeakly(CGSize.self, "contentSize")
               .subscribe(onNext: { [weak self] size in
                   DispatchQueue.main.async { [weak self] in
                       guard let contentSize = size, let tableSize = self?.tableView.frame.size else { return }
                       if contentSize.height > tableSize.height {
                           self?.tableView.alwaysBounceVertical = true
                       }
                   }
               })
               .disposed(by: rx.disposeBag)
       }
}
