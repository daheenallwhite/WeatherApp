//
//  StringInterpolation.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(temperature value: Temperature) {
        appendInterpolation("\(value.text)\(UnitSymbol.forTemperature)")
    }
    
    mutating func appendInterpolation(pressure value: Double) {
        let convertedPressure = "\(Int(value))"
        appendInterpolation("\(convertedPressure) \(UnitSymbol.forPressure)")
    }
    
    mutating func appendInterpolation(clouds value: Clouds) {
        appendInterpolation("\(value.all) \(UnitSymbol.forClouds)")
    }
    
    mutating func appendInterpolation(wind value: Wind) {
        let directionText = "\(value.direction)".uppercased()
        appendInterpolation("\(directionText) \(Int(value.deg)) \(UnitSymbol.forWindDegree)")
    }
    
    mutating func appendInterpolation(humidity value: Int) {
        appendInterpolation("\(value) \(UnitSymbol.forHumidity)")
    }
}

