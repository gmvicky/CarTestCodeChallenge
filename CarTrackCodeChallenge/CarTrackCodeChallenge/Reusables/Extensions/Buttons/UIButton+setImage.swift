//
//  UIButton+setImage.swift
//  Speshe
//
//  Created by WT-iOS on 3/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AlamofireImage

//struct ImageSourceString {
//    var sourceType: UIImageView.ImageSourceType
//    var name: String?
//}

extension UIButton {
    
    func util_setImage(source: UIImageView.ImageSourceType?) {
        guard let source = source else {
            setImage(UIImage.systemImageFromConstant(name: .personCircle), for: .normal)
            return
        }
        
        switch source {
        case .defaultAssets(let imageName):
            guard let imageName = imageName else { return }
            setImage(UIImage(named: imageName), for: .normal)
        case .remoteUrl(let imageName):
            guard let aImageName = imageName,
                let url = URL(string: aImageName) else { return }
            af.setImage(for: .normal, url: url)
        case .imageData(let imageData):
            setImage(imageData, for: .normal)
        case .localUrl(let url):
            guard let aURL = url else { return }
            
            if FileManager.default.fileExists(atPath: aURL.path),
                let imageData = try? Data(contentsOf: aURL) {
                setImage(UIImage(data: imageData), for: .normal)
            }
        case .remoteUrlCompletion(let imageName, let completion, let placeHolder):
            guard let aImageName = imageName,
                let url = URL(string: aImageName) else { return }
            af.setImage(for: .normal, url: url, placeholderImage: placeHolder) { completion($0.value) }
        }
    }
}

extension Reactive where Base: UIButton {
    var imageSourceType: Binder<UIImageView.ImageSourceType?> {
        return Binder(base) { button, imageSourceType in
            guard let aImageSourceType = imageSourceType else { return }
            button.util_setImage(source: aImageSourceType)
        }
    }
}
