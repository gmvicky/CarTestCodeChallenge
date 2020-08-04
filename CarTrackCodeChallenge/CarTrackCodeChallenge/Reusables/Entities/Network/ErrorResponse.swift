//
//  ErrorResponse.swift
//  InstantMac
//
//  Created by Paul Sevilla on 22/05/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case status
        case data
        case message
    }
    
    var status: ResultResponse?
    var data: [String: Any]?
    var message: String?
    
    init (from decoder: Decoder) throws {
         let container =  try decoder.container (keyedBy: CodingKeys.self)
         status = try container.decode (ResultResponse.self, forKey: .status)
        data = try container.decode ([String: Any].self, forKey: .data)
         message = try container.decode (String.self, forKey: .message)
    }
    
    func encode (to encoder: Encoder) throws
    {
         var container = encoder.container (keyedBy: CodingKeys.self)
         try container.encode (status, forKey: .status)
        if let data = data {
            try container.encode (data, forKey: .data)
        }
         
         try container.encode (message, forKey: .message)
    }
}


