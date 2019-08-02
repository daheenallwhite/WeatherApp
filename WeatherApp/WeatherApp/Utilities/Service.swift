//
//  Service.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class Service {
    static private func getQueryItems(from coordinate: Coordinate) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let latitudeQuery = URLQueryItem(name: "lat", value: coordinate.latitude)
        let longtitudeQuery = URLQueryItem(name: "lon", value: coordinate.longitude)
        let appIdQuery = URLQueryItem(name: "APPID", value: WeatherAPI.appID)
        queryItems.append(contentsOf: [latitudeQuery, longtitudeQuery, appIdQuery])
        return queryItems
    }
    
    static func getWeatherForecastURL(using coordinate: Coordinate) -> URL? {
        var urlComponents = URLComponents(string: WeatherAPI.forecastURL)
        urlComponents?.queryItems = getQueryItems(from: coordinate)
        return urlComponents?.url
    }
}
