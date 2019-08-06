//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class CurrentWeather: Weather, WeatherPresentable {
    var icon: UIImage {
        return WeatherIconImagePicker.getImage(named: iconName)
    }
    
    var temperatureText: String {
        return "\(temperature: self.temperature)"
    }
    
    var dateText: String {
        return self.date.getDayOfWeek()
    }
    
    let condition: String
    
    init(iconName: String, temperature: Double, condition: String, date: Date) {
        self.condition = condition
        super.init(iconName: iconName, temperature: temperature, date: date)
    }
}
