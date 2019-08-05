//
//  WeatherBuilder.swift
//  WeatherApp
//
//  Created by Daheen Lee on 06/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class WeatherBuilder {
    private let data: WeatherData
    private let maxItemCount = 25
    private var timezone: Int = 0 {
        didSet {
            self.utcTimeConverter = DateConverter(timezone: timezone)
        }
    }
    private var utcTimeConverter = DateConverter(timezone: 0)
    
    init(data: WeatherData) {
        self.data = data
        timezone = data.city.timezone
    }
    
    func getCurrentWeather() -> CurrentWeather {
        let weather = data.list[0].weather[0]
        let firstListItem = data.list[0]
        let convertedDate = utcTimeConverter.convertDateFromUTC(string: firstListItem.dtTxt)
        return CurrentWeather(iconName: weather.icon, temperature: firstListItem.main.temp, condition: weather.description, date: convertedDate)
    }
    
    func getHourlyWeatherItems() -> [HourlyWeatherItem] {
        let maxCount = data.list.count > maxItemCount ? maxItemCount : data.list.count
        let weatherList = data.list[0...maxCount]
        return weatherList.map { (list) -> HourlyWeatherItem in
            let temp = list.main.temp
            let iconName = list.weather[0].icon
            let convertedDate = utcTimeConverter.convertDateFromUTC(string: list.dtTxt)
            return HourlyWeatherItem(iconName: iconName, temperature: temp, date: convertedDate)
        }
    }
    
    func getDailyWeatherItems() -> [DailyWeatherItem] { // date, icon, temperature-min/max
        var minTemperature = [String: Double]()
        var maxTemperature = [String: Double]()
        var firstDate = [String: Date]()
        var firstIcon = [String: String]()
        for item in data.list {
            let dayOfWeek = utcTimeConverter.convertDateFromUTC(string: item.dtTxt).getDayOfWeek()
            minTemperature.merge([dayOfWeek: item.main.tempMin]) { return $0 > $1 ? $1 : $0 }
            maxTemperature.merge([dayOfWeek: item.main.tempMax]) { return $0 > $1 ? $0 : $1 }
            firstDate.merge([dayOfWeek: utcTimeConverter.convertDateFromUTC(string: item.dtTxt)]) { (first, second) in first }
            firstIcon.merge([dayOfWeek: item.weather[0].icon]) { (first, second) in first }
        }
        var dailyWeatherItems = [DailyWeatherItem]()
        for key in minTemperature.keys {
            let dailyWeatherItem = DailyWeatherItem(iconName: firstIcon[key]!, date: firstDate[key]!, maxTemperature: maxTemperature[key]!, minTemperature: minTemperature[key]!)
            dailyWeatherItems.append(dailyWeatherItem)
        }
        return dailyWeatherItems.sorted(by: { (first, second) in
            first.date < second.date
        })
    }
}