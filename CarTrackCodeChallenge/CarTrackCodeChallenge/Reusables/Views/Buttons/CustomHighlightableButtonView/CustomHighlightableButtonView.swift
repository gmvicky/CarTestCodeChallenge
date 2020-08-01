//
//  CustomHighlightableButtonView.swift
//  Speshe
//
//  Created by WT-iOS on 3/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class CustomHighlightableButtonView: UIView {
    
    @IBOutlet weak var customButton: HighlightButton!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet var highlightableViews: [CustomHighlightableViewProtocol]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customButton.delegate = self
    }
}


extension CustomHighlightableButtonView: HighlightButtonDelegate {
    
    func isHighlighted(flag: Bool) {
        highlightableViews.forEach { $0.customHighlightedStateChange(flag: flag)}
    }
}

protocol HighlightButtonDelegate: class {
    
    func isHighlighted(flag: Bool)
}

class HighlightButton: UIButton {
    
    weak var delegate: HighlightButtonDelegate?
    
    override open var isHighlighted: Bool {
        didSet { delegate?.isHighlighted(flag: isHighlighted) }
    }
}
