//
//  Coordinate.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation
import CoreLocation

class Coordinate {
    let latitude: String
    let longitude: String
    
    init(location: CLLocation) {
        let maxLength = 10
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let lengthModifiedLatitude = latitude.prefix(latitude.count > maxLength ? maxLength : latitude.count)
        let lengthModifiedlongitude = longitude.prefix(longitude.count > maxLength ? maxLength : longitude.count)
        self.latitude = String(lengthModifiedLatitude)
        self.longitude =  String(lengthModifiedlongitude)
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = String(coordinate.latitude)
        self.longitude =  String(coordinate.longitude)
    }
    
    init(lat: String, lon: String) {
        self.latitude = lat
        self.longitude = lon
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "lat: \(self.latitude), lon: \(self.longitude)"
    }
}

extension Coordinate: Equatable {
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
