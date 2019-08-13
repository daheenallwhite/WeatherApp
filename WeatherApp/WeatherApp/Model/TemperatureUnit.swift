//
//  TemperatureUnitState.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

enum TemperatureUnit {
    case celcius, fahrenheit
    
    static var shared = TemperatureUnit()
    
    init() {
        let bool = UserDefaults.standard.bool(forKey: DataKeys.temperatureUnit)
        self = TemperatureUnit(bool: bool)
    }
    
    init(bool: Bool) {
        self = bool ? .celcius : .fahrenheit
    }
    
    var boolValue: Bool {
        return self == .celcius ? true : false
    }
}
