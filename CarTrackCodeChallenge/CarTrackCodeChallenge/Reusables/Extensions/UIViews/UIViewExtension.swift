//
//  UIViewExtension.swift
//  DinDinn
//
//  Created by Coco Xtet Pai on 3/18/18.
//  Copyright © 2018 nexlabs. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func imageWithColor(_ color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func twoDigitString() -> String {
        
        return String(format: "%.2f", self)
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Float {
    
    func twoDigitString() -> String {
        
        return String(format: "%.2f", self)
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UINavigationController {
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popViewController(animated: Bool,
                                  completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}

extension UISearchBar {
    
    func customize() {
        
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in self.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UISearchBarBackground) {
                    subview.alpha = 0

                }
            }
        }
        
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            textfield.layer.cornerRadius = 18
            textfield.backgroundColor = .black
            textfield.clipsToBounds = true
        }
    }
}

extension UILabel {
    
    func normalize() {
        
        guard let attributedText = self.attributedText else { return }

        let textString = attributedText.string
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: textString)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedText.length))

        self.attributedText = attributeString
        self.text = textString
    }
    
    func strikethrough() {
        
        guard let textString = self.text else { return }
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: textString)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.text = ""
        self.attributedText = attributeString

    }
}

extension String {
    
    func strikethrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension Date {
    
    func componentsFrom(date: Date) -> DateComponents {
        
        return Calendar.current.dateComponents([.weekday ,.day, .hour, .minute, .second], from: date, to: self)

    }
}

extension String {
    
    func toInt() -> Int {
        
        return Int(self) ?? 0
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func getFlag() -> String {
        
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}

extension UIView {
    
    // MARK: Bounce and Shake
    
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    /** Loads instance from nib with the same name. */
    
    func setShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        //        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        
    }
    
    func dropShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowColor = UIColor.red.cgColor
//        layer.shadowOffset = CGSize(width: -8, height: -8)
      
        layer.shadowRadius = 17
        layer.shadowOffset = CGSize.zero
        
        layer.shadowOpacity = 1
        
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offset: CGSize, radius: CGFloat = 0, scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func loadNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func getTextField() -> UITextField? {
        
        for view in self.subviews {
            
            if view.tag == 13 {
                
                if let textField = view as? UITextField {
                    
                    return textField
                }
            }
        }
        
        return nil
    }
    
    func getTitleLabel() -> UILabel? {
        
        for view in self.subviews {
            
            if view.tag == 12 {
                
                if let label = view as? UILabel {
                    
                    return label
                }
            }
        }
        
        return nil
    }
    
    func getMessageLabel() -> UILabel? {
        
        for view in self.subviews {
            
            if view.tag == 11 {
                
                if let label = view as? UILabel {
                    
                    return label
                }
            }
        }
        
        return nil
    }
}
