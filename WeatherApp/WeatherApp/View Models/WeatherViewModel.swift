//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Daheen Lee on 03/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class WeatherViewModel {
    let maxItemCount = 20
    let emptyString = ""
    let coordinate: Coordinate
    let city: Observable<String>
    let currentWeather: Observable<CurrentWeather>
    let dailyWeatherItems: Observable<[DailyWeatherItem]>
    let hourlyWeatherItems: Observable<[HourlyWeatherItem]>
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
        city = Observable(emptyString)
        currentWeather = Observable(CurrentWeather(iconName: emptyString, temperature: 0.0, condition: emptyString, date: emptyString))
        dailyWeatherItems = Observable([])
        hourlyWeatherItems = Observable([])
    }
    
    func retrieveWeatherData() {
        OpenWeatherMapService.retrieveWeatherInfo(using: coordinate) { (weather, error) in
            guard let weatherData = weather, error == nil else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.update(using: weatherData)
            }
        }
    }
    
    func update(using data: WeatherData) {
        self.city.value = data.city.name
        setCurrentWeather(from: data)
        setHourlyWeatherItems(from: data)
        setDailyWeatherItems(from: data)
    }
    
    func setCurrentWeather(from data: WeatherData) {
        let weather = data.list[0].weather[0]
        let firstListItem = data.list[0]
        currentWeather.value = CurrentWeather(iconName: weather.icon, temperature: firstListItem.main.temp, condition: weather.description, date: firstListItem.dtTxt)
    }
    
    func setHourlyWeatherItems(from data: WeatherData) {
        let maxCount = data.list.count > maxItemCount ? maxItemCount : data.list.count
        let weatherList = data.list[0...maxCount]
        hourlyWeatherItems.value = weatherList.map{ (list) -> HourlyWeatherItem in
            let temp = list.main.temp
            let date = list.dtTxt
            let iconName = list.weather[0].icon
            return HourlyWeatherItem(iconName: iconName, temperature: temp, date: date)
        }
    }
    
    func setDailyWeatherItems(from data: WeatherData) {
        let maxCount = data.list.count > maxItemCount ? maxItemCount : data.list.count
        dailyWeatherItems.value = data.list[0...maxCount].map{ (list) -> DailyWeatherItem in
            let max = list.main.tempMax
            let min = list.main.tempMin
            let date = list.dtTxt
            let iconName = list.weather[0].icon
            return DailyWeatherItem(iconName: iconName, date: date, maxTemperature: max, minTemperature: min)
        }
    }
}
