//
//  Company.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 5/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation

struct Company: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case basicSystem = "bs"
        case catchPhrase
        case name
    }
    
    var basicSystem: String?
    var catchPhrase: String?
    var name: String?
}
