//
//  DetailTableViewCell.swift
//  WeatherApp
//
//  Created by Daheen Lee on 07/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    static let identifier = "DetailTableViewCell"
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftValueLable: UILabel!
    @IBOutlet weak var rightTitleLable: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWeatherData(using weatherAtRow: DetailWeather.DetailWeatherAtRow) {
        let (left, right) = weatherAtRow
        self.leftTitleLabel.text = left.title
        self.leftValueLable.text = left.value
        self.rightTitleLable.text = right.title
        self.rightValueLabel.text = right.value
    }
}
