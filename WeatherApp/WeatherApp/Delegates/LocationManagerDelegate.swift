//
//  LocationManagerDelegate.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

protocol LocationManagerDelegate {
    func locationManagerDidUpdate(currenLocation: Location)
}
