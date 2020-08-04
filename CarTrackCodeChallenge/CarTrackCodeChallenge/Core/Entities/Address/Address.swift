//
//  Address.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation

class Address: NSObject, Codable {
    
    private enum CodingKeys: String, CodingKey {
        case city
        case suite
        case street
        case zipcode
        case geo
    }
    
    var city: String?
    var geo: GeoCoordinates?
    var suite: String?
    var street: String?
    var zipcode: String?
    
    var formattedAddress: String {
        return "\(suite ?? String()) \(street ?? String())\n\(city ?? String()) \(zipcode ?? String())"
        
//        """
//                \(suite ?? String()) \(street ?? String())
//                \(city ?? String()) \(zipcode ?? String())
//                """
    }
}

struct GeoCoordinates: Codable {
    private enum CodingKeys: String, CodingKey {
         case lng
         case lat
     }
    
    var lng: String?
    var lat: String?
}

