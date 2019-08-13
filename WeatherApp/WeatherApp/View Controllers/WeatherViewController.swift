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
    static let identifier = "WeatherViewController"
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var location : Location!
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
                self.dayOfWeekLabel.text = $0.dateText
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
            viewModel.temperatureUnit.observe { [unowned self] unit in
                self.temperatureLabel.text = viewModel.currentWeather.value?.temperatureText
                self.dailyTableView.reloadData()
                self.hourlyCollectionView.reloadData()
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
        super.viewWillAppear(animated)
        let temperatureUnit = TemperatureUnit.shared.unit
        if viewModel?.temperatureUnit.value != temperatureUnit {
            viewModel?.temperatureUnit.value = temperatureUnit
        }
        print("view will appear as index \(self.index)")
    }
    
    private func setEmptyStringToLables() {
        let emptyString = ""
        self.cityLabel.text = emptyString
        self.conditionLabel.text = emptyString
        self.temperatureLabel.text = emptyString
    }
    
    private func registerDailyTableViewCells() {
        let dailyTableViewCellNib = UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
        dailyTableView.register(dailyTableViewCellNib, forCellReuseIdentifier: DailyTableViewCell.identifier)
        let detailTableViewCell = UINib(nibName: DetailTableViewCell.identifier, bundle: nil)
        dailyTableView.register(detailTableViewCell, forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    private func getWeatherData() {
        print("get weather")
        guard let location = self.location else {
            print(LocationError.noLocationConfigured.localizedDescription)
            return
        }
        self.viewModel = WeatherViewModel(location: location)
        self.viewModel?.retrieveWeatherData()
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.hourlyWeatherItems.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else {
            return HourlyCollectionViewCell()
        }
        guard let weatherItem = viewModel?.hourlyWeatherItems.value?[indexPath.row] else {
            return HourlyCollectionViewCell()
        }
        cell.setWeatherData(from: weatherItem)
        return cell
    }
    
}

extension WeatherViewController: UITableViewDataSource { 
    func numberOfSections(in tableView: UITableView) -> Int {
        return DailyTableViewSection.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DailyTableViewSection(sectionIndex: section) else {
            return 0
        }
        switch section {
        case .daily:
            return viewModel?.dailyWeatherItems.value?.count ?? 0
        case .detail:
            return viewModel?.detailWeather.value?.totalRow ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DailyTableViewSection(sectionIndex: indexPath.section) else {
            return DailyTableViewCell()
        }
        switch section {
        case .daily:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell,
                let weatherItem = viewModel?.dailyWeatherItems.value?[indexPath.row] else {
                return DailyTableViewCell()
            }
            cell.setWeatherData(from: weatherItem)
            return cell
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell,
                let weatherPair = viewModel?.detailWeather.value?.getDetailWeather(at: indexPath.row) else {
                return DetailTableViewCell()
            }
            cell.setWeatherData(using: weatherPair)
            return cell
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = DailyTableViewSection(sectionIndex: indexPath.section) else {
            return DailyTableViewSection.defaultCellHeight
        }
        return section.cellHeight
    }
}

