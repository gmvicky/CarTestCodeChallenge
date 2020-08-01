//
//  MobileCountryModel.swift
//  Speshe
//
//  Created by WT-iOS on 26/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import PrivatePod4

struct CustomCountryModel {    
    var countryName: String?
    var countryId: String?
    var currencyCode: String?
    var phoneCode: String?
    var countryFlag: String?
    var countryFlagImage: UIImage?
    var countryCode: String?
}

extension CustomCountryModel: CustomCountryModelProtocol {
    
}
