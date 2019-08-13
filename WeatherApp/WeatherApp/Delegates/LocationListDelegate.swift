//
//  LocationListDelegate.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

protocol LocationListViewDelegate: AnyObject {
    func userDidSelectLocation(at index: Int)
    func userAdd(newLocation: Location)
    func userDeleteLocation(at index: Int)
}
