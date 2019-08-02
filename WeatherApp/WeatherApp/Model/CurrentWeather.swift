//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class CurrentWeather: WeatherPresentable {
    var icon: UIImage {
        return WeatherIconImagePicker.getImage(named: iconName)
    }
    
    var temperatureText: String {
        return "\(self.currentTemperature.toCelcius)"
    }
    
    var dateText: String {
        return DateConverter.getDayOfWeek(from: self.date)
    }
    
    let city: String
    let condition: String
    private let iconName: String
    private let currentTemperature: Temperature
    private let date: Date
    
    init(city: String, iconName: String, temperature: Double, condition: String, date: String) {
        self.city = city
        self.iconName = iconName
        self.currentTemperature = Temperature(kelvin: temperature)
        self.condition = condition
        self.date = DateConverter.getDate(from: date)
    }
}
