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
    @IBOutlet weak var condionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    let locationManager = CLLocationManager()
    
    var coordinate : Coordinate?
    
    //MARK: ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            viewModel.city.observe { [unowned self] in
                self.cityLabel.text = $0
            }
            viewModel.currentWeather.observe { [unowned self] in
                self.condionLabel.text = $0.condition
                self.temperatureLabel.text = $0.temperatureText
                self.weatherIconImageView.image = $0.icon
            }
            viewModel.hourlyWeatherItems.observe { [unowned self] list in
                self.hourlyCollectionView.reloadData()
            }
            viewModel.dailyWeatherItems.observe { [unowned self] list in
                self.dailyTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        coordinate = ("37.5665", "126.978")
        self.temperatureLabel.text = ""
        self.hourlyCollectionView.dataSource = self
        self.hourlyCollectionView.delegate = self
        self.dailyTableView.dataSource = self
        self.dailyTableView.delegate = self
        dailyTableView.separatorStyle = .none
        
        if coordinate == nil {
            print("location needed")
            self.locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
                locationManager.requestLocation()
            }
        } else {
            getWeatherData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        super.viewWillAppear(animated)
        if coordinate != nil, viewModel == nil {
            getWeatherData()
        }
    }
    
    func getWeatherData() {
        print("get weather")
        if let coordinate = coordinate {
            viewModel = WeatherViewModel(coordinate: coordinate)
        }
        if let viewModel = viewModel{
            viewModel.retrieveWeatherData()
        }
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coordinate = location.coordinate.getCoordinatePairString()
            print("\(String(describing: coordinate))")
            getWeatherData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
