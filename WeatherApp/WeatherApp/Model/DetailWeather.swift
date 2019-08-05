//
//  DetailWeather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 06/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class DetailWeather {
    let humidity: Int
    let pressure: Pressure
    let wind: Wind
    let clouds: Clouds
    
    init(humidity: Int, pressure: Pressure, wind: Wind, clouds: Clouds) {
        self.humidity = humidity
        self.pressure = pressure
        self.wind = wind
        self.clouds = clouds
    }
}

class Pressure {
    let regular: Int
    let seaLevel: Int
    let groundLevel: Int
    
    init(regular: Double, seaLevel: Double, groundLevel: Double) {
        self.regular = Int(regular)
        self.seaLevel = Int(seaLevel)
        self.groundLevel = Int(groundLevel)
    }
    
}
