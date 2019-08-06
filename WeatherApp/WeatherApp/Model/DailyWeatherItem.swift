//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class DailyWeatherItem: Weather, WeatherPresentable {
    var icon: UIImage {
        return WeatherIconImagePicker.getImage(named: iconName)
    }
    
    var temperatureText: String {
        let max = "\(temperature: maxTemperature)"
        let min = "\(temperature: minTemperature)"
        return "\(max)  \(min)"
    }
    
    var dateText: String {
        return self.date.getDayOfWeek()
    }

    private let maxTemperature: Temperature
    private let minTemperature: Temperature
    
    init(iconName: String, date: Date, maxTemperature: Double, minTemperature: Double) {
        self.maxTemperature = Temperature(kelvin: maxTemperature)
        self.minTemperature = Temperature(kelvin: minTemperature)
        super.init(iconName: iconName, temperature: minTemperature, date: date)
    }
}
