//
//  Temperature.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class Temperature {
    static let celciusGap = 273.15
    static let fahrenheitGap = 459.67
    let kelvinValue: Double
    
    init(kelvin: Double) {
        self.kelvinValue = kelvin
    }
    
    var text: String {
        let temperatureUnit = UserDefaults.standard.bool(forKey: DataKeys.temperatureUnit)
        return temperatureUnit ? "\(toCelcius)" : "\(toFahrenheit)"
    }
    
    var toCelcius: Int {
        return Int(kelvinValue - Temperature.celciusGap)
    }
    
    var toFahrenheit: Int {
        return Int(kelvinValue - Temperature.fahrenheitGap)
    }
}
