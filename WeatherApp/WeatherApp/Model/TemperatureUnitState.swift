//
//  TemperatureUnitState.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class TemperatureUnitState {
    static var shared = TemperatureUnitState()
    var unit: TemperatureUnit
    
    init() {
        let bool = UserDefaults.standard.bool(forKey: DataKeys.temperatureUnit)
        self.unit = TemperatureUnit(bool: bool)
    }
}

enum TemperatureUnit {
    case celcius, fahrenheit
    init(bool: Bool) {
        self = bool ? .celcius : .fahrenheit
    }
    
    var boolValue: Bool {
        return self == .celcius ? true : false
    }
}
