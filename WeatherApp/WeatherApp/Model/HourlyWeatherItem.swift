
//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class HourlyWeatherItem: WeatherPresentable {
    var icon: UIImage {
        return UIImage(named: self.iconName) ?? UIImage()
    }
    
    var temperatureText: String {
        return "\(self.currentTemperature.toCelcius)"
    }
    
    var dateText: String {
        return DateConverter.getHour(from: self.date)
    }
    
    private let iconName: String
    private let currentTemperature: Temperature
    private let date: Date
    
    init(iconName: String, temperature: Double, date: String) {
        self.iconName = iconName
        self.currentTemperature = Temperature(kelvin: temperature)
        self.date = DateConverter.getDate(from: date)
    }
}
