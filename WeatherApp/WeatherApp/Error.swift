//
//  Error.swift
//  WeatherApp
//
//  Created by Daheen Lee on 03/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case urlError
    case networkRequestError
    case impossibleToGetJSONData
    case impossibleToParseJSON
    case impossibleToGetCurrentLocation
}

enum CreationError: Error {
    case downcastingError(String)
    case noLocationConfigured
    
    var detail: String {
        switch self {
        case let .downcastingError(toType):
            return "\(self) \(toType)"
        case .noLocationConfigured:
            return "location is not assinged for weather view controller"
        }
    }
}
