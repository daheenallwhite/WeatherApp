//
//  DateConverter.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class DateConverter {
    static func getDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
    
    // 이후에 string interpolation 구현 하기
    static func getDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    static func getHour(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
    
    let timezone: Double
    
    init(timezone: Int) {
        self.timezone = Double(timezone)
    }
    
    func convertDateFromUTC(string: String) -> Date {
        let utcDate = DateConverter.getDate(from: string)
        return utcDate.addingTimeInterval(self.timezone)
    }
}
