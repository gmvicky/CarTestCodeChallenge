//
//  Address+MKAnnotationn.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import MapKit

extension Address: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        guard let geo = geo,
        let latitudeString = geo.lat,
        let latitude = Double(latitudeString),
        let longitudeString = geo.lng,
        let longitude = Double(longitudeString) else { return CLLocationCoordinate2D(latitude: -1, longitude: -1) }
        return CLLocationCoordinate2D(latitude: 1.349591, longitude: 103.956787)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? { return street }

    var subtitle: String? { return city }
}
