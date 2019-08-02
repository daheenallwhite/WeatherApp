//
//  Coordinate.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation
import CoreLocation

typealias Coordinate = (latitude: String, longitude: String)

extension CLLocationCoordinate2D {
    func getCoordinatePair() -> Coordinate {
        let latitude = String(self.latitude)
        let longitude = String(self.longitude)
        return (latitude, longitude)
    }
}
