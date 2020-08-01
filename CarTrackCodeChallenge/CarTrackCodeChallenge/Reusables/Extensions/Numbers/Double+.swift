//
//  Double+.swift
//  Speshe
//
//  Created by WT-iOS on 7/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation

extension Double {
    
    private static var formatterDecimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private static var formatterDecimalRemoverIfEmpty: NumberFormatter = {
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
        return Double.formatterDecimal.string(from: NSNumber(value:self)) ?? String(self)
    }
    
    var removeDecimalIfEmpty: String {
        return Double.formatterDecimalRemoverIfEmpty.string(from: NSNumber(value:self)) ?? String(self)
    }
    
    var percentString: String {
        return Double.formatterPercentage.string(from: NSNumber(value:self)) ?? String(self)
    }
    
    var singleDecimal: String {
        return Double.formatterSingleDecimal.string(from: NSNumber(value:self)) ?? String(self)
    }
}

extension Double {
    
    private static var formatterDecimalAndCommas: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
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
    
    internal var commaWithDecimals: String {
        return Double.formatterDecimalAndCommas.string(from: NSNumber(value: self)) ?? String(self)
    }
    
    internal var commaWithDecimalsMinOneMaxTwo: String {
        return Double.formatterDecimalAndCommasMinOneMaxTwo.string(from: NSNumber(value: self)) ?? String(self)
    }
    
    var isInteger: Bool { rounded() == self }
}
