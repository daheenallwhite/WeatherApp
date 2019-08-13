//
//  DetailWeather.swift
//  WeatherApp
//
//  Created by Daheen Lee on 06/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class DetailWeather {
    typealias DetailWeatherAtRow = (TitleValuePair, TitleValuePair)
    typealias TitleValuePair = (title: String, value: String)
    
    private struct Constants {
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let seaLevelPressure = "sea level pressure"
        static let groundLevelPressure = "ground level pressure"
        static let wind = "wind"
        static let clouds = "clouds"
    }
    
    var titleValuPairs = [TitleValuePair]()
    var totalRow: Int {
        return self.titleValuPairs.count / 2
    }
    
    init(humidity: Int, regularPressure: Double, seaLevelPressure: Double, groundLevelPressure: Double, wind: Wind, clouds: Clouds) {
        titleValuPairs.append((Constants.humidity, "\(humidity: humidity)"))
        titleValuPairs.append((Constants.pressure, "\(pressure: regularPressure)"))
        titleValuPairs.append((Constants.seaLevelPressure, "\(pressure: seaLevelPressure)"))
        titleValuPairs.append((Constants.groundLevelPressure, "\(pressure: groundLevelPressure)"))
        titleValuPairs.append((Constants.wind, "\(wind: wind)"))
        titleValuPairs.append((Constants.clouds, "\(clouds: clouds)"))
    }
    
    func getDetailWeather(at rowIndex: Int) -> DetailWeatherAtRow {
        let index = rowIndex * 2
        let leftItem = titleValuPairs[index]
        let rightItem = titleValuPairs[index + 1]
        return (leftItem, rightItem)
    }
}
