//
//  CountryModel.swift
//  FrontRow
//
//  Created by WT-iOS on 4/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit

protocol CountryModelProtocol {
    var flag: UIImage? { get }
    var dialCode: String? { get }
    var countryCode: String? { get }
    var countryName: String? { get }

}

extension CountryModelProtocol {
    var countryName: String? {
        guard let countryCode = countryCode else { return nil }
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
}

struct CountryModel: CountryModelProtocol, Codable, Equatable {
    
    var flag: UIImage?
    let dialCode: String?
    let countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case dialCode = "dialCode"
        case countryCode = "countryCode"
    }
    
    init(flag: UIImage?,
         dialCode: String?,
         countryCode: String?) {
        self.flag = flag
        self.dialCode = dialCode
        self.countryCode = countryCode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dialCode = try container.decode(String.self, forKey: CodingKeys.dialCode)
        countryCode = try container.decode(String.self, forKey: CodingKeys.countryCode)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dialCode, forKey: .dialCode)
        try container.encode(countryCode, forKey: .countryCode)
    }
    
    static func ==(lhs: CountryModel, rhs: CountryModel) -> Bool {
        return lhs.dialCode == rhs.dialCode &&
        lhs.countryCode == rhs.countryCode
    }
}
