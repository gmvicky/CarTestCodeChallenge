//
//  UIImage+systemName.swift
//  PrivatePod4
//
//  Created by WT-iOS on 20/2/20.
//

import UIKit

public extension UIImage {
    
    enum UIImageNameConstants: String {
        case multiply = "multiply"
        case person = "person"
        case lockShield = "lock.shield"
        case chevronLeft = "chevron.left"
        case qrCode = "qrcode"
        case arrowRightArrowLeftSquareFill = "arrow.right.arrow.left.square.fill"
        case calendar = "calendar"
        case personCircle = "person.circle"
        case person2Fill = "person.2.fill"
        case personCropCircleFill = "person.crop.circle.fill"
        case gear = "gear"
    }
    
    static func systemImageFromConstant(name: UIImageNameConstants) -> UIImage? {
        return UIImage(systemName: name.rawValue)
    }
    
}
