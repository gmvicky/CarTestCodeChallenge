//
//  UserDetail.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation

struct UserDetail: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case username
        case id
        case email
        case phone
        case name
        case website
        case address
        case company
    }
    
    var username: String?
    var email: String?
    var address: Address?
    var phone: String?
    var id: Int?
    var name: String?
    var website: String?
    var company: Company?
    
}
