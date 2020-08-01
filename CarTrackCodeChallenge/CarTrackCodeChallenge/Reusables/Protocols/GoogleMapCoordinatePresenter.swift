//
//  GoogleMapCoordinatePresenter.swift
//  PrivatePod4
//
//  Created by WT-iOS on 1/3/20.
//

import UIKit

//public class GoogleMapCoordinatePresenter {
//    
//    public static func viewInMap(latitude: String?,
//                          longitude: String?,
//                          name: String?) {
//        guard let latitude = latitude,
//            let longitude = longitude else { return }
//
//        let queryString: String
//        if let queryLocation = name {
//            queryString = "center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(queryLocation.replacingOccurrences(of: " ", with: "+"))"
//        } else {
//            queryString = "center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)"
//        }
//
//        let url: URL?
//        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
//            url = URL(string: "comgooglemaps://?\(queryString)")
//        } else {
//            print("Can't use comgooglemaps://")
//            url = URL(string: "http://maps.google.com/maps?\(queryString)")
//        }
//
//        if let aUrl = url {
//            UIApplication.shared.open(aUrl, options: [:], completionHandler: nil)
//        }
//    }
//}
