//
//  AuthenticationModel.swift
//  FrontRow
//
//  Created by WT-iOS on 5/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import PhoneNumberKit

protocol AuthenticationModelProtocol {
    
    var countryInfo: CountryModelProtocol? { get set }
    var mobileNumber: String? { get set }
    var completeMobileNumber: String? { get }
    var completeMobileNumberDigitsOnly: String? { get }
    
    func isValid() -> Bool
    func formattedLocalNumber() -> String?
    func formattedCompleteNumber() -> String?
}


extension AuthenticationModelProtocol {
    
    func isValid() -> Bool {
        guard let mobileNumber = mobileNumber,
            mobileNumber.isNotEmpty else { return false }
        return MobileNumberEntryViewModel.isValidMobileNumber(selectedCountryCode: countryInfo?.countryCode, mobileNumber: mobileNumber)
    }
}

struct AuthenticationModel: AuthenticationModelProtocol, Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case countryInfo = "countryInfo"
        case mobileNumber = "mobileNumber"
    }
    
    var countryInfo: CountryModelProtocol?
    var mobileNumber: String? {
        get { return rawLocalNumber }
        set { rawLocalNumber = newValue }
    }
    
    private var rawLocalNumber: String? = nil
    
    init(countryInfo: CountryModelProtocol?,
         mobileNumber: String?) {
        self.countryInfo = countryInfo
        self.mobileNumber = mobileNumber
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countryInfo = try? container.decode(CountryModel.self, forKey: CodingKeys.countryInfo)
        mobileNumber = try? container.decode(String.self, forKey: CodingKeys.mobileNumber)
    }
    
    func formattedLocalNumber() -> String? {
        return format(prefix: false)
    }
    
    func formattedCompleteNumber() -> String? {
        return format(prefix: true)
    }
    
    private func format(prefix: Bool) -> String? {
        guard let text = mobileNumber,
            let region = countryInfo?.countryCode else { return mobileNumber }
        
        let phoneNumberKit = PhoneNumberKitInstanceManager.shared.phoneNumberKit
        if let phoneNumber = try? phoneNumberKit.parse(text, withRegion: region, ignoreType: true) {
            let format = phoneNumberKit.format(phoneNumber, toType: .international, withPrefix: prefix)
            return format
        }
        return text
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let countryModel = countryInfo as? CountryModel {
            try container.encode(countryModel, forKey: .countryInfo)
        }
        try container.encode(mobileNumber, forKey: .mobileNumber)
    }
    
    var completeMobileNumber: String? {
        guard let countryInfo = countryInfo else { return mobileNumber }
        return "\(countryInfo.dialCode ?? String())\(mobileNumber ?? String())".removingWhitespaces()
    }
    
    var completeMobileNumberDigitsOnly: String? {
        guard let countryInfo = countryInfo else { return mobileNumber }
        return "\(countryInfo.dialCode ?? String())\(mobileNumber ?? String())".numericOnly.removingWhitespaces()
    }
    
    static func == (lhs: AuthenticationModel, rhs: AuthenticationModel) -> Bool {
        guard let left = lhs.countryInfo as? CountryModel, let right = rhs.countryInfo as? CountryModel else {
            return false
        }
        return left == right &&
            lhs.mobileNumber == rhs.mobileNumber
    }
}
