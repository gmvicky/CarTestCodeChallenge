//
//  ResultResponse.swift
//  DinDinn
//
//  Created by DD_01 on 12/3/19.
//  Copyright © 2019 DinDinn. All rights reserved.
//

import Foundation

class ResultResponse: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case statusCode = "statusCode"
    }
    
    var success: Bool?
    var message: String?
    var statusCode: Int?
}

