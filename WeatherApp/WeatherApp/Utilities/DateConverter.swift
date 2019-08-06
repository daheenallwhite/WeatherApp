//
//  DateConverter.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

class DateConverter {
    private let timezone: Double
    
    init(timezone: Int) {
        self.timezone = Double(timezone)
    }
    
    func convertDateFromUTC(string: String) -> Date {
        let utcDate = convertDate(from: string)
        return utcDate.addingTimeInterval(self.timezone)
    }
    
    private func convertDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
}

