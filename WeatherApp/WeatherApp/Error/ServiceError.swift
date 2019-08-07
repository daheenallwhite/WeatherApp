//
//  ServiceError.swift
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
}


