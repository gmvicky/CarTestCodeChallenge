//
//  UIView+.swift
//  InstantMac
//
//  Created by Harold on 26/03/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let aColor = layer.borderColor else { return nil }
            return UIColor(cgColor: aColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
  
  var allSubviews: [UIView] {
    var subviews = [UIView]()
    func subview(of view: UIView, isSelf: Bool = false) {
      guard view.subviews.count > 0 else { return }
      !isSelf ? subviews.append(view) : ()
      view.subviews.forEach { subview(of: $0) }
    }
    subview(of: self, isSelf: true)
    return subviews
  }
  
  var allSuperviews: [UIView] {
    var superviews = [UIView]()
    func superview(of view: UIView, isSelf: Bool = false) {
      guard let view = view.superview else { return }
//      !isSelf ? superviews.append(view) : ()
      superviews.append(view)
      superview(of: view)
    }
    superview(of: self, isSelf: true)
    return superviews
  }
  
  func containsViews(withTypes types: [UIView.Type]) -> Bool {
    return types.contains(where: { viewType in
      var isTypeOfView = type(of: self) == viewType
      // If self does not match with the type, check its superviews
      if !isTypeOfView {
        isTypeOfView = allSuperviews.contains(where: { type(of: $0) == viewType })
      }
      return isTypeOfView
    })
  }
  
  func roundCorners() {
    clipsToBounds = true
    layer.cornerRadius = min(bounds.height, bounds.width) * 0.5
  }
  
  func curveAllCorners(withRadius radius: CGFloat) {
    clipsToBounds = true
    layer.cornerRadius = radius
  }
  
  func curveCorners(_ corners: UIRectCorner, radius: CGFloat) {
    DispatchQueue.main.async {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
  }
    
    func addShadow(color: UIColor? = .lightGray, radius: CGFloat = 6.0, size: CGSize = CGSize(width: 0, height: 3), opacity: Float = 0.4) {
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = size
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    static let curveWithShadowLayerKey = "shadowWithCurveLayer"
    
    func curveAllCornersWithShadow(withRadius radius: CGFloat, color: UIColor? = .lightGray) {
        
        let key = UIView.curveWithShadowLayerKey
        if let currentShadowLayer = layer.sublayers?.first(where: { $0.name == key }) {
            currentShadowLayer.removeFromSuperlayer()
        }
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.needsDisplayOnBoundsChange = true
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = color?.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2
        shadowLayer.name = key
        layer.insertSublayer(shadowLayer, at: 0)
        layer.masksToBounds = false
    }
  
  @discardableResult
  func applyDashedBorder(withCurveRadius curveRadius: CGFloat = 0.0,
                         dashColor: UIColor,
                         backgroundColor: UIColor = .clear,
                         fillColor: UIColor = .clear,
                         lineDashPattern: [NSNumber]? = [3, 3]) -> CALayer {
    let customLayer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: curveRadius)
    
    customLayer.path            = path.cgPath
    customLayer.strokeColor     = dashColor.cgColor
    customLayer.lineDashPattern = lineDashPattern
    customLayer.backgroundColor = backgroundColor.cgColor
    customLayer.fillColor       = fillColor.cgColor
    
    layer.addSublayer(customLayer)
    
    return customLayer
  }
  
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
  
    static func loadFromNib<T: UIView>(name: String, bundle: Bundle? = nil) -> T {
    guard let view = UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? T else { fatalError("Unable to load view from nibname \(name)")}
    return view
  }
    
    static var bundle: Bundle {
        return Bundle(for: self.classForCoder())
    }
    
    static func loadFromNib<T: ViewReusable>() -> T {
        guard let view = UINib(nibName: T.nibName, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? T else { fatalError("Unable to load view from nibname \(T.nibName)")}
        
        return view
    }
}
