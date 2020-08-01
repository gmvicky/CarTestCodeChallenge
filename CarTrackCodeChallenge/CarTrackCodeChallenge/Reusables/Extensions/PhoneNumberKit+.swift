//
//  PhoneNumberKit+.swift
//  Speshe
//
//  Created by WT-iOS on 1/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import PhoneNumberKit

extension PhoneNumberKit {
    func parseWithFixedRegion(_ numberString: String, withRegion region: String = PhoneNumberKit.defaultRegionCode(), ignoreType: Bool = false, withPrefix: Bool = false) throws -> String {
         
        if let phoneNumber = try? parse(numberString, withRegion: region, ignoreType: false), phoneNumber.regionID == region {
           let format = self.format(phoneNumber, toType: .international, withPrefix: withPrefix)
           return format
       }
       return numberString
    }
    
    func parseForceAddPlus(_ numberString: String) throws -> PhoneNumber {
         
        var phone = numberString
        if phone.prefix(1) != "+" {
           phone = "+\(phone)"
        }
        return try parse(phone)
    }
}

extension String {
    
    var parseForceAddPlus: String {
        let phone = try? PhoneNumberKitInstanceManager.shared.phoneNumberKit.parseForceAddPlus(self)
        
        if let aPhone = phone {
            return PhoneNumberKitInstanceManager.shared.phoneNumberKit.format(aPhone, toType: .international, withPrefix: true)
        }
        return self
    }
}

extension Optional where Wrapped == String {
  
    var parseForceAddPlus: String {
        guard let aString = self else { return String() }
        return aString.parseForceAddPlus
    }
}
