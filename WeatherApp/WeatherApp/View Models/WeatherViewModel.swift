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
    var location: Observable<Location>
    let currentWeather: Observable<CurrentWeather>
    let dailyWeatherItems: Observable<[DailyWeatherItem]>
    let hourlyWeatherItems: Observable<[HourlyWeatherItem]>
    
    init(location: Location) {
        self.location = Observable(location)
        currentWeather = Observable(CurrentWeather(iconName: emptyString, temperature: 0.0, condition: emptyString, date: Date()))
        dailyWeatherItems = Observable([])
        hourlyWeatherItems = Observable([])
    }
    
    func retrieveWeatherData() {
        OpenWeatherMapService.retrieveWeatherInfo(using: location.value) { (weather, error) in
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
        if self.location.value.name == nil {
            self.location.value.name = data.city.name
        }
        let weatherBuilder = WeatherBuilder(data: data)
        currentWeather.value = weatherBuilder.getCurrentWeather()
        hourlyWeatherItems.value = weatherBuilder.getHourlyWeatherItems()
        dailyWeatherItems.value = weatherBuilder.getDailyWeatherItems()
    }
}
