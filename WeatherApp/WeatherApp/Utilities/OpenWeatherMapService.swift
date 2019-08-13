//
//  Service.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

typealias WeatherCompletionHandler = (WeatherData?, ServiceError?) -> Void

class OpenWeatherMapService {
    static func retrieveWeatherInfo(using location: Location, completionHandler: @escaping WeatherCompletionHandler) {
        guard let url = getWeatherForecastURL(using: location) else {
            let error = ServiceError.urlError
            completionHandler(nil, error)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                let error = ServiceError.networkRequestError
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                let error = ServiceError.impossibleToGetJSONData
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            guard let parsedWeatherData = try? decoder.decode(WeatherData.self, from: data) else {
                let error = ServiceError.impossibleToParseJSON
                completionHandler(nil, error)
                return
            }
            completionHandler(parsedWeatherData, nil)
        }
        task.resume()
    }
    
    static func getWeatherForecastURL(using location: Location) -> URL? {
        var urlComponents = URLComponents(string: WeatherAPI.forecastURL)
        urlComponents?.queryItems = getQueryItems(from: location)
        return urlComponents?.url
    }
    
    static private func getQueryItems(from location: Location) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let latitudeQuery = URLQueryItem(name: "lat", value: location.coordinate.latitude)
        let longtitudeQuery = URLQueryItem(name: "lon", value: location.coordinate.longitude)
        let appIdQuery = URLQueryItem(name: "appid", value: WeatherAPI.appID)
        queryItems.append(contentsOf: [latitudeQuery, longtitudeQuery, appIdQuery])
        return queryItems
    }
}
