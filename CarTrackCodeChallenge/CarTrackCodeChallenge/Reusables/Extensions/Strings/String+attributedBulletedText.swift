//
//  String+attributedBulletedText.swift
//  xApp
//
//  Created by WT-iOS on 18/12/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import UIKit

extension Array where Element == String {
    
    func bulletedText(font: UIFont? = UIFont.systemFont(ofSize: 14),
                      bullet: String = "●",
                      indentation: CGFloat = 20,
                      lineSpacing: CGFloat = 2,
                      paragraphSpacing: CGFloat = 12,
                      textColor: UIColor = .black,
                      bulletColor: UIColor = .black) -> NSAttributedString {
        
        let aFont = font ?? UIFont.systemFont(ofSize: 14)
        
        let textAttributes = [NSAttributedString.Key.font: aFont, NSAttributedString.Key.foregroundColor: textColor] as [NSAttributedString.Key : Any]
        
        
        let bulletAttributes = [NSAttributedString.Key.font: aFont, NSAttributedString.Key.foregroundColor: bulletColor] as [NSAttributedString.Key : Any]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        for string in self {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }

        return bulletList
    }
    
}
