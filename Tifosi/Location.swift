//
//  Location.swift
//  Tifosi
//
//  Created by COBE Osijek on 03/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation

struct Location {
    let latitude: String
    let longitude: String
}

class CustomLocationManager {
    
    let locationManager = CLLocationManager()
    private var locValue: CLLocationCoordinate2D?
    
    init() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locValue = locationManager.location?.coordinate
        }
    }
    
    func getPosition() -> CLLocation {
        return CLLocation(latitude: locValue?.latitude ?? -82.0, longitude: locValue?.longitude ?? 135.0)
    }
    
    func getDistanceFromCurrent(location: CLLocation) -> Double {
        let currentPosition = CLLocation(latitude: locValue?.latitude ?? -82.0, longitude: locValue?.longitude ?? 135.0)
        return (currentPosition.distance(from: location)) / 1000
    }
    
}
