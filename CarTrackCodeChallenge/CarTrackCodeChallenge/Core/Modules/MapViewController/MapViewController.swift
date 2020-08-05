//
//  MapViewController.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController<MapViewModel> {
    
    @IBOutlet weak var visualEffectBackground: VisualEffectBackgroundButtonView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        visualEffectBackground.backgroundButton.rx.action = viewModel.onClose
        
        mapView.centerToLocation(CLLocation(latitude: viewModel.location.coordinate.latitude, longitude: viewModel.location.coordinate.longitude) )
        
        mapView.addAnnotation(viewModel.location)
    }
    
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
    let coordinateRegion = MKCoordinateRegion(
        center: location.coordinate,
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
