//
//  Weather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 03/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class Weather {
    let iconName: String
    let temperature: Temperature
    let date: Date
    
    init(iconName: String, temperature: Double, date: String) {
        self.iconName = iconName
        self.temperature = Temperature(kelvin: temperature)
        self.date = DateConverter.getDate(from: date)
    }
}
