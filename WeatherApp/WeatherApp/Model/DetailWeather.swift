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
    var titleValuPairs = [TitleValuePair]()
    var totalRow: Int {
        return self.titleValuPairs.count / 2
    }
    
    init(humidity: Int, regularPressure: Double, seaLevelPressure: Double, groundLevelPressure: Double, wind: Wind, clouds: Clouds) {
        titleValuPairs.append(("humidity", "\(humidity)"))
        titleValuPairs.append(("pressure", "\(regularPressure)"))
        titleValuPairs.append(("sea level pressure", "\(seaLevelPressure)"))
        titleValuPairs.append(("ground level pressure", "\(groundLevelPressure)"))
        titleValuPairs.append(("wind", "\(wind.speedText)"))
        titleValuPairs.append(("clouds", "\(clouds.text)"))
    }
    
    func getDetailWeather(at rowIndex: Int) -> DetailWeatherAtRow {
        let leftItem = titleValuPairs[rowIndex]
        let rightItem = titleValuPairs[rowIndex + 1]
        return (leftItem, rightItem)
    }
}
