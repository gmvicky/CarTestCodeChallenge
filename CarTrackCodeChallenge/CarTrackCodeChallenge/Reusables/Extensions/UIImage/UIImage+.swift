//
//  UIImage+.swift
//  InstantMac
//
//  Created by Harold on 16/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit

extension UIImage {
  
  class func image(withColor color: UIColor) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1);
    UIGraphicsBeginImageContext(rect.size);
    
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    context.setFillColor(color.cgColor)
    context.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
//  class func image(withCGColor cgColor: CGColor) -> UIImage? {
//    let layerGradient = CAGradientLayer()
//    layerGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//    layerGradient.frame = tabBar.frame
//    layerGradient.locations = [0.0, 0.05]
//    return layerGradient
//  }
  
  class func image(withView view: UIView, isOpaque: Bool = false) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, isOpaque, 0.0)
    defer { UIGraphicsEndImageContext() }
    if let context = UIGraphicsGetCurrentContext() {
      view.layer.render(in: context)
      return UIGraphicsGetImageFromCurrentImageContext()
    }
    return nil
  }
    
    func resize(withMaximumDimension dimension: CGFloat, useScreenScale: Bool = true) -> UIImage {
        guard size.width > dimension || size.height > dimension else { return self }
        let ratio: CGFloat
        
        if size.width > dimension && size.height > dimension {
            let widthRatio  = dimension  / size.width
            let heightRatio = dimension / size.height
            ratio = min(widthRatio, heightRatio)
        } else if size.width > dimension {
            ratio = dimension / size.width
        } else if size.height > dimension {
            ratio = dimension / size.height
        } else {
            return self
        }
        
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        let scale = useScreenScale ? UIScreen.main.scale : 1.0
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
  
  func resize(withMinimumSize newSize: CGSize, useScreenScale: Bool = true) -> UIImage {
    let widthRatio  = newSize.width  / size.width
    let heightRatio = newSize.height / size.height
    
    let ratio = max(widthRatio, heightRatio)
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    let scale = useScreenScale ? UIScreen.main.scale : 1.0
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
    draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  func resize(withMaximumSize newSize: CGSize, useScreenScale: Bool = true) -> UIImage {
    let widthRatio  = newSize.width  / size.width
    let heightRatio = newSize.height / size.height
    
    let ratio = min(widthRatio, heightRatio)
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    let scale = useScreenScale ? UIScreen.main.scale : 1.0
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
    draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

extension UIImage {
    
    struct GradientPoint {
        var location: CGFloat
        var color: UIColor
    }
    
    convenience init?(size: CGSize, gradientPoints: [GradientPoint]) {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }       // If the size is zero, the context will be nil.
        guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: gradientPoints.compactMap { $0.color.cgColor.components  }.flatMap { $0 }, locations: gradientPoints.map { $0.location }, count: gradientPoints.count) else {
            return nil
        }
        
        context.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions())
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        self.init(cgImage: image)
        defer { UIGraphicsEndImageContext() }
    }
}

extension UIImage {
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    static func getImageFrom(gradientLayer:RadialGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}


extension UIImageView {
    func gradient(gradientPoints: [UIImage.GradientPoint]) {
        let gradientMaskLayer       = CAGradientLayer()
        gradientMaskLayer.frame     = frame
        gradientMaskLayer.colors    = gradientPoints.map { $0.color.cgColor }
        gradientMaskLayer.locations = gradientPoints.map { $0.location as NSNumber }
        self.layer.insertSublayer(gradientMaskLayer, at: 0)
    }
}
