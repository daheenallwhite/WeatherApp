//
//  Location.swift
//  WeatherApp
//
//  Created by Daheen Lee on 05/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

struct Location: Codable, Equatable {
    let coordinate: Coordinate
    var name: String?
    
    init(coordinate: Coordinate, name: String? = nil) {
        self.coordinate = coordinate
        self.name = name
    }
}
