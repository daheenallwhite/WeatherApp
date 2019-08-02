//
//  WeatherListItem.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

protocol WeatherPresentable {
    var icon: UIImage { get }
    var temperatureText: String { get }
    var dateText: String { get }
}
