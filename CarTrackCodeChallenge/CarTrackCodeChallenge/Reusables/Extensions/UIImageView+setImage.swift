//
//  UIImageView+setImage.swift
//  xApp
//
//  Created by WT-iOS on 7/11/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

//struct ImageSourceString {
//    var sourceType: UIImageView.ImageSourceType
//    var name: String?
//}

extension UIImageView {
    
    enum ImageSourceType {
        case defaultAssets(String?)
        case remoteUrl(String?)
        case imageData(UIImage?)
        case localUrl(URL?)
        case remoteUrlCompletion(String?, ((UIImage?)->()), placeholder: UIImage?)
    }
//    public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
//        let url = try url.asURL()
//
//        self.init(url: url)
//
//        httpMethod = method.rawValue
//        allHTTPHeaderFields = headers?.dictionary
//    }
    
    func util_setImage(source: ImageSourceType?) {
        guard let source = source else {
            image = UIImage.systemImageFromConstant(name: .personCircle)
            return
        }
        
        switch source {
        case .defaultAssets(let imageName):
            guard let imageName = imageName else { return }
            image = UIImage(named: imageName)
        case .remoteUrl(let imageName):
            guard let aImageName = imageName,
                let url = URL(string: aImageName),
                let aUrlRequest = try? URLRequest(url: url, method: .get) else { return }
            
            af.setImage(withURLRequest: aUrlRequest, imageTransition: .crossDissolve(0.2))
        case .imageData(let imageData):
            image = imageData
        case .localUrl(let url):
            guard let aURL = url else { return }
            
            if FileManager.default.fileExists(atPath: aURL.path),
                let imageData = try? Data(contentsOf: aURL) {
                image = UIImage(data: imageData)
            }
        case .remoteUrlCompletion(let imageName, let completion, let placeHolder):
            guard let aImageName = imageName,
                let url = URL(string: aImageName),
                let aUrlRequest = try? URLRequest(url: url, method: .get) else { return }
            af.setImage(withURLRequest: aUrlRequest, placeholderImage: placeHolder, imageTransition: .crossDissolve(0.2), completion: {
                completion($0.value)
            })
        }
    }
}

extension Reactive where Base: UIImageView {
    var imageSourceType: Binder<UIImageView.ImageSourceType?> {
        return Binder(base) { imageView, imageSourceType in
            guard let aImageSourceType = imageSourceType else { return }
            imageView.util_setImage(source: aImageSourceType)
        }
    }
}


extension UIImageView.ImageSourceType: Codable {
    
    enum CodingKeys: CodingKey {
        case defaultAssets
        case remoteUrl
        case imageData
        case localUrl
        case remoteUrlCompletion
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let defaultAssets =  try? container.decode(String.self, forKey: .defaultAssets) {
            self = .defaultAssets(defaultAssets)
        } else if let url =  try? container.decode(String.self, forKey: .remoteUrl) {
            self = .remoteUrl(url)
        } else if let data = (try? container.decode(Data.self, forKey: .imageData)) {
            self = .imageData(UIImage(data: data))
        } else if let url = (try? container.decode(URL.self, forKey: .localUrl)) {
            self = .localUrl(url)
        }  else if let url =  try? container.decode(String.self, forKey: .remoteUrlCompletion) {
            self = .remoteUrl(url)
        }
        else {
            self = .defaultAssets(nil)
        }
        
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .defaultAssets(let value):
            try container.encode(value, forKey: .defaultAssets)
        case .remoteUrl(let value):
            try container.encode(value, forKey: .remoteUrl)
        case .imageData(let imageData):
            try container.encode(imageData?.pngData(), forKey: .imageData)
        case .localUrl(let url):
            try container.encode(url, forKey: .localUrl)
        case .remoteUrlCompletion(let value, _, _):
            try container.encode(value, forKey: .remoteUrl)
        }
    }
    
    var staticImage: UIImage? {
        switch self {
        case .defaultAssets(let name):
            guard let name = name else { return nil }
            return UIImage(named: name)
        case .remoteUrl, .remoteUrlCompletion:
            return nil
        case .imageData(let image):
            return image
           
        case .localUrl(let url):
            guard let aURL = url else { return nil }
                       
            if FileManager.default.fileExists(atPath: aURL.path),
                let imageData = try? Data(contentsOf: aURL) {
                return UIImage(data: imageData)
            }
            return nil
        }
    }
}
