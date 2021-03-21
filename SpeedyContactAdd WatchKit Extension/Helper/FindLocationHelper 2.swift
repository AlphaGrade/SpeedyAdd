//
//  FindLocationHelper.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Joe on 5/25/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//
import CoreLocation
import Foundation

extension InterfaceController: CLLocationManagerDelegate {
    func getLocation() -> (Double, Double, Date) {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()                                            
        manager.requestLocation()
        let latitude = manager.location?.coordinate.latitude ?? 37.33182
        let longitude = manager.location?.coordinate.longitude ?? -122.03118
        let date = Date()
        return (latitude, longitude, date)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error finding location: \(error)")
    }
}
