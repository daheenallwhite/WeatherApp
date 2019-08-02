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
        let maxLength = 10
        let latitude = String(self.latitude)
        let longitude = String(self.longitude)
        let lengthModifiedLatitude = latitude.prefix(latitude.count > maxLength ? maxLength : latitude.count)
        let lengthModifiedlongitude = longitude.prefix(longitude.count > maxLength ? maxLength : longitude.count)
        return (String(lengthModifiedLatitude), String(lengthModifiedlongitude))
    }
}
