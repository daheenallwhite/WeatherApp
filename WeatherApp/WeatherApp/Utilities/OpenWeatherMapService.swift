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
    static func retrieveWeatherInfo(using coordinate: Coordinate, completionHandler: @escaping WeatherCompletionHandler) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        guard let url = getWeatherForecastURL(using: coordinate) else {
            let error = ServiceError.urlError
            completionHandler(nil, error)
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check network error
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
            // view model 에 weather builder 통해 데이터 파싱하여 저장            
            completionHandler(parsedWeatherData, nil)
        }
        task.resume()
    }
    
    static private func getQueryItems(from coordinate: Coordinate) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let latitudeQuery = URLQueryItem(name: "lat", value: coordinate.latitude)
        let longtitudeQuery = URLQueryItem(name: "lon", value: coordinate.longitude)
        let appIdQuery = URLQueryItem(name: "appid", value: WeatherAPI.appID)
        queryItems.append(contentsOf: [latitudeQuery, longtitudeQuery, appIdQuery])
        return queryItems
    }
    
    static func getWeatherForecastURL(using coordinate: Coordinate) -> URL? {
        var urlComponents = URLComponents(string: WeatherAPI.forecastURL)
        urlComponents?.queryItems = getQueryItems(from: coordinate)
        return urlComponents?.url
    }
    
}
