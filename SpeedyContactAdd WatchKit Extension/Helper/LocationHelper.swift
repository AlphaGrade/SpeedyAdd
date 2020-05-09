//
//  LocationHelper.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Joe on 5/8/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation
import CoreLocation

extension InterfaceController: CLLocationManagerDelegate {
    
    func getLocation() -> (Double, Double, Date) {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestLocation()
        let latitude = manager.location?.coordinate.latitude ?? 0
        let longitude = manager.location?.coordinate.longitude ?? 0
        let date = (manager.location?.timestamp)!
        return (latitude, longitude, date)
        
    }
    
}
