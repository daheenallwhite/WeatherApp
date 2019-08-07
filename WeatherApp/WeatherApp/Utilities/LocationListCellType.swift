//
//  LocationListSection.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

enum LocationListCellType: Int {
    static let numberOfSections = 2
    
    case currentLocation = 0
    case savedLocations
    
    init?(rowIndex: Int) {
        self = rowIndex == LocationListCellType.currentLocation.rawValue ? .currentLocation : .savedLocations
    }
    
    var canEditRows: Bool {
        switch self {
        case .currentLocation:
            return false
        case .savedLocations:
            return true
        }
    }
    
    var defaultText: String? {
        switch self {
        case .currentLocation:
            return "Current Location"
        case .savedLocations:
            return nil
        }
    }
}
