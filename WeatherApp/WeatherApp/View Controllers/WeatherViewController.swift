//
//  ViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!

    var location : Location?
    var index = 0
    
    //MARK: ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            viewModel.location.observe { [unowned self] in
                if let cityName = $0.name {
                    self.cityLabel.text = cityName
                }
            }
            viewModel.currentWeather.observe { [unowned self] in
                self.conditionLabel.text = $0.condition
                self.temperatureLabel.text = $0.temperatureText
            }
            viewModel.hourlyWeatherItems.observe { [unowned self] list in
                self.hourlyCollectionView.reloadData()
            }
            viewModel.dailyWeatherItems.observe { [unowned self] list in
                self.dailyTableView.reloadData()
            }
            viewModel.detailWeather.observe { [unowned self] list in
                self.dailyTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load at index \(self.index)")
        registerDailyTableViewCells()
        self.hourlyCollectionView.dataSource = self
        self.dailyTableView.dataSource = self
        self.dailyTableView.delegate = self
        self.dailyTableView.separatorStyle = .none
        if let cityName = location?.name {
            self.cityLabel.text = cityName
        }
        getWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear as index \(self.index)")
        super.viewWillAppear(animated)
        if location != nil, viewModel == nil {
            getWeatherData()
        }
    }
    
    func getWeatherData() {
        print("get weather")
        guard let location = self.location else {
            print(CreationError.noLocationConfigured)
            return
        }
        self.viewModel = WeatherViewModel(location: location)
        self.viewModel?.retrieveWeatherData()
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.hourlyWeatherItems.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else {
            return HourlyCollectionViewCell()
        }
        guard let weatherItem = viewModel?.hourlyWeatherItems.value[indexPath.row] else {
            return HourlyCollectionViewCell()
        }
        cell.setWeatherData(from: weatherItem)
        return cell
    }
    
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dailyWeatherItems.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else {
            return DailyTableViewCell()
        }
        guard let weatherItem = viewModel?.dailyWeatherItems.value[indexPath.row] else {
            return DailyTableViewCell()
        }
        cell.setWeatherData(from: weatherItem)
        return cell
    }
}
