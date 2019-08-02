//
//  WeatherIconImagePicker.swift
//  WeatherApp
//
//  Created by Daheen Lee on 03/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class WeatherIconImagePicker {
    static var icons = [String: UIImage]()
    
    static func getImage(named name: String) -> UIImage {
        if icons.keys.contains(name) {
            return icons[name] ?? UIImage()
        } else {
            let newImage = UIImage(named: name) ?? UIImage()
            icons[name] = newImage
            return newImage
        }
    }
}
