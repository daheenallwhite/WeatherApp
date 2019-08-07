//
//  DailyTableViewSection.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

enum DailyTableViewSection: Int {
    static let numberOfSections = 2
    static let defaultCellHeight: CGFloat = 44
    
    case daily = 0
    case detail = 1
    
    init?(sectionIndex: Int) {
        guard let section = DailyTableViewSection(rawValue: sectionIndex) else {
            return nil
        }
        self = section
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .daily:
            return DailyTableViewCell.height
        case .detail:
            return DetailTableViewCell.height
        }
    }
}
