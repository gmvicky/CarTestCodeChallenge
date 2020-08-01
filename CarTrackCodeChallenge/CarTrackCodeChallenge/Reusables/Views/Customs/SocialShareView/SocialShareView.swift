//
//  SocialShareView.swift
//  Speshe
//
//  Created by WT-iOS on 22/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class SocialShareView: UIView, ViewReusable, ViewCoderLoadable {
    
    @IBOutlet weak var shareButton: UIButton!
    
    var viewModel: SocialShareViewModelProtocol? {
        didSet { setupObservers() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        setUpLoadableView()
        
        shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill")?.resize(withMinimumSize: CGSize(width: 25, height: 25)), for: .normal)
        
        
    }
    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        shareButton.rx.action = viewModel.onShowShareOptions
//            .bind(to: viewModel.onShowShareOptions.inputs)
//            .disposed(by: rx.disposeBag)
        
    }
}
