//
//  Float+.swift
//  FrontRow
//
//  Created by WT-iOS on 18/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation

extension Float {
    
    private static var formatterDecimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static var formatterDecimalRemoverIfEmpty: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private static var formatterSingleDecimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private static var formatterPercentage: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        return formatter
    }()
    
    var withCommas: String {
        return Float.formatterDecimal.string(from: NSNumber(value:self)) ?? String(self)
    }
    
    var removeDecimalIfEmpty: String {
        return Float.formatterDecimalRemoverIfEmpty.string(from: NSNumber(value:self)) ?? String(self)
    }
    
    var percentString: String {
        return Float.formatterPercentage.string(from: NSNumber(value:self)) ?? String(self)
    }
    
    var singleDecimal: String {
        return Float.formatterSingleDecimal.string(from: NSNumber(value:self)) ?? String(self)
    }
}

extension Float {
    
    static var formatterDecimalAndCommas: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfEven
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private static var formatterDecimalAndCommasMinOneMaxTwo: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static var formatterMinTwo: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    internal var commaWithDecimals: String {
        return Float.formatterDecimalAndCommas.string(from: NSNumber(value: self)) ?? String(self)
    }
    
    internal var commaWithDecimals2: String {
        return Float.formatterDecimalAndCommas.string(from: NSNumber(value: self)) ?? String(self)
    }
    
    internal var commaWithDecimalsMinOneMaxTwo: String {
        return Float.formatterDecimalAndCommasMinOneMaxTwo.string(from: NSNumber(value: self)) ?? String(self)
    }
    
    var isInteger: Bool { rounded() == self }
}
