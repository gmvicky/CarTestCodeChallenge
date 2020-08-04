//
//  MapViewModel.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import MapKit

protocol MapViewModelProtocol: BaseViewModelProtocol {
    var location: MKAnnotation { get }
}

class MapViewModel: BaseViewModel, MapViewModelProtocol {
    
    let location: MKAnnotation
    
    init(router: RouterProtocol,
         location: MKAnnotation) {
        self.location = location
        super.init(router: router)
    }
    
}
