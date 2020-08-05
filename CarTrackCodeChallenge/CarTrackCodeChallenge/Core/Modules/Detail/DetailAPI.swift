//
//  DetailAPI.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import Moya
import Rswift

enum DetailAPI {
    case users(parameters: [String: Any])
}

extension DetailAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    var path: String {
        switch self {
        case .users:
            return "users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .users:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .users(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}
