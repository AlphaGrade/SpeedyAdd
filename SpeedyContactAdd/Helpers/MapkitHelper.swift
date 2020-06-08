//
//  MapkitHelper.swift
//  SpeedyContactAdd
//
//  Created by Joe on 5/7/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//
import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion (
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        pin.title = "Where contact was recorded"
        addAnnotation(pin)
    }
    
    
}
