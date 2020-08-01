//
//  SlidingTabView.swift
//  Speshe
//
//  Created by WT-iOS on 27/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class SlidingTabView: UIView, ViewCoderLoadable {
    
    weak var viewModel: SlidingTabViewModelProtocol? { didSet { configureTabs() }}
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
    }
    
    private func configureTabs() {
        viewModel?.configureTabs(header: headerCollectionView, content: contentCollectionView)
    }
}

