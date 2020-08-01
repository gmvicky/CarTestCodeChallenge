//
//  HeaderCollectionViewCell.swift
//  Speshe
//
//  Created by WT-iOS on 3/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell, ViewReusable {
    
    @IBOutlet weak var separatorRight: UIView!
    @IBOutlet weak var separatorLeft: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customSelectedBackgroundView: UIView!
    
    var customSelectedState: Bool = false {
        didSet {
            if customSelectedState {
                nameLabel.textColor = .white
                customSelectedBackgroundView.isHidden = false
            } else {
                customSelectedBackgroundView.isHidden = true
                nameLabel.textColor = R.color.brownGrey() ?? .lightGray
            }
        }
    }
    
    func shouldHideSeparators(flag: Bool) {
//        DispatchQueue.main.async {
//
//        }
        self.separatorRight.isHidden = flag
        self.separatorLeft.isHidden = flag
    }
}
