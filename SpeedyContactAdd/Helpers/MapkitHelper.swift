//
//  MapkitHelper.swift
//  SpeedyContactAdd
//
//  Created by Joe on 5/7/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import MapKit

    // Credit - https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}