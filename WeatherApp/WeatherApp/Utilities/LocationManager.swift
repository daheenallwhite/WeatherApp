//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Daheen Lee on 06/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationManagerDidUpdate(currenLocation: Location)
}

class LocationManager: NSObject {
    var delegate: LocationManagerDelegate?
    private let manager = CLLocationManager()
    var didUpdateCurrentLocation = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            manager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let currentLocation = Location(coordinate: Coordinate(coordinate: location.coordinate))
            print("\(currentLocation)")
            if didUpdateCurrentLocation { // for preventing creation of current weather view more than twice
                return
            }
            didUpdateCurrentLocation.toggle()
            self.delegate?.locationManagerDidUpdate(currenLocation: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: did fail to get current location")
    }
}
