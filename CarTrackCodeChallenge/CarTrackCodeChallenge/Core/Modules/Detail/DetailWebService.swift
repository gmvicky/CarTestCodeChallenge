//
//  DetailWebService.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailWebServiceProtocol {
    func users(parameters: [String: Any]) -> Observable<[UserDetail]>
    
}

struct DetailWebService: DetailWebServiceProtocol {
    
    private let service: WebService<DetailAPI>
    
    init(service: WebService<DetailAPI> = WebService<DetailAPI>()) {
        self.service = service
    }
    
    func users(parameters: [String: Any]) -> Observable<[UserDetail]> {
        return service.requestCollection(path: .users(parameters: parameters))
    }
}
