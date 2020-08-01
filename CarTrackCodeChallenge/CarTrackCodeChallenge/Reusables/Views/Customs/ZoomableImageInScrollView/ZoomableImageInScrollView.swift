//
//  ZoomableImageInScrollView.swift
//  Speshe
//
//  Created by WT-iOS on 30/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class ZoomableImageInScrollView: UIView, ViewCoderLoadable {
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
    }
}
