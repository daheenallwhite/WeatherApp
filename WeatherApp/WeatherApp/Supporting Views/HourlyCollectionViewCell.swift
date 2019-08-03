//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func setWeatherData(from weatherItem : HourlyWeatherItem) {
        self.temperatureLabel.text = weatherItem.temperatureText
        self.hourLabel.text = weatherItem.dateText
        self.weatherIconImageView.image = weatherItem.icon
    }
}
