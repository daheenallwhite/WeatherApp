//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    static let identifier = "DailyTableViewCell"
    static let height: CGFloat = 44

    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maxMinTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.textColor = .white
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.dayOfWeekLabel.textColor = .white
        self.maxMinTemperatureLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWeatherData(from weatherItem: WeatherPresentable) {
        self.weatherIconImageView.image = weatherItem.icon
        self.dayOfWeekLabel.text = weatherItem.dateText
        self.maxMinTemperatureLabel.text = weatherItem.temperatureText
    }

}
