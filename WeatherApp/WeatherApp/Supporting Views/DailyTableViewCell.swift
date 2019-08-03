//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    static let identifier = "DailyTableViewCell"

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maxMinTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.textColor = .white
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.dayLabel.textColor = .white
        self.maxMinTemperatureLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWeatherData(from weatherItem: DailyWeatherItem) {
        self.weatherIconImageView.image = weatherItem.icon
        self.dayLabel.text = weatherItem.dateText
        self.maxMinTemperatureLabel.text = weatherItem.temperatureText
    }

}
