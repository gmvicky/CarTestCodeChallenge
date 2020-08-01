//
//  BasicCellCustomizer.swift
//  Speshe
//
//  Created by WT-iOS on 5/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import UIKit


protocol BasicCellCustomizer {
//    var itemTitle: String? { get }
    var customTypes: [CellCustomizerType] { get }
}

protocol BasicCellProtocol {
    var customizer: BasicCellCustomizer? { get set }
    var customProperties: BasicCellCustomProperties { get }
}


//protocol BasicCellButtonCustomizer: BasicCellCustomizer {
//    func customizeMainButton(_ button: UIButton)
//}
//
//protocol BasicCellSecondLabelCustomizer: BasicCellCustomizer {
//    var secondItemTitle: String? { get }
//}


enum CellCustomizerType {
    case mainText(() -> (String?))
    case secondaryText(() -> (String?))
    case mainButton((UIButton?) -> ())
    case secondaryButton((UIButton?) -> ())
    case mainImage(() -> (UIImage?))
}

struct BasicCellCustomProperties {
    
    weak var mainLabel: UILabel? = nil
    weak var secondaryLabel: UILabel? = nil
    weak var mainButton: UIButton? = nil
    weak var secondaryButton: UIButton? = nil
    weak var mainImage: UIImageView? = nil
    
    func loadCustomizers(_ customizers: [CellCustomizerType]) {
        customizers.forEach {
            switch $0 {
            case .mainText(let loader):
                self.mainLabel?.text = loader()
            case .secondaryText(let loader):
                self.secondaryLabel?.text = loader()
            case .mainButton(let loader):
                loader(self.mainButton)
            case .secondaryButton(let loader):
                loader(self.secondaryButton)
            case .mainImage(let loader):
                self.mainImage?.image = loader()
            }
        }
    }
}
