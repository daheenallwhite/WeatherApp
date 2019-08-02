//
//  ViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 02/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var condionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    let locationManager = CLLocationManager()
    let maxItemCount = 20
    
    var currentWeather: CurrentWeather!
    var dailyWeatherItems = [DailyWeatherItem]()
    var hourlyWeatherItems = [HourlyWeatherItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation() //Asynchronous
        // didUpdataLocation <- when it's done updating
        
        self.hourlyCollectionView.dataSource = self
        self.hourlyCollectionView.delegate = self
        self.dailyTableView.dataSource = self
        self.dailyTableView.delegate = self
        dailyTableView.separatorStyle = .none
    }
    
    func getQueryItems(latitude: String, longtitude: String) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let latitudeQuery = URLQueryItem(name: "lat", value: latitude)
        let longtitudeQuery = URLQueryItem(name: "lon", value: longtitude)
        let appIdQuery = URLQueryItem(name: "APPID", value: WeatherAPI.appID)
        queryItems.append(contentsOf: [latitudeQuery, longtitudeQuery, appIdQuery])
        return queryItems
    }
    
    func getWeatherData(using coordinate: Coordinate) {
        guard let weatherRequestURL = Service.getWeatherForecastURL(using: coordinate) else {
            return
        }
        let dataTask = URLSession.shared.weatherTask(with: weatherRequestURL) {
            [weak self] (data: Weather?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("DataTask error:  \(error.localizedDescription)")
            }
            guard let data = data else {
                print("json parsing error")
                return
            }
            DispatchQueue.main.async {
                self?.saveResponse(from: data)
            }
        }
        dataTask.resume()
    }
    
    func saveResponse(from data: Weather) {
        saveCurrentWeather(from: data)
        saveHourlyWeatherItems(from: data)
        saveDailyWeatherItems(from: data)
        updateWeatherLabels()
    }
    
    func saveCurrentWeather(from data: Weather) {
        let weather = data.list[0].weather[0]
        let firstListItem = data.list[0]
        currentWeather = CurrentWeather(city: data.city.name, iconName: weather.icon, temperature: firstListItem.main.temp, condition: weather.weatherDescription, date: firstListItem.dtTxt)
    }
    
    func saveHourlyWeatherItems(from data: Weather) {
        let maxCount = data.list.count > maxItemCount ? maxItemCount : data.list.count
        let weatherList = data.list[0...maxCount]
        hourlyWeatherItems = weatherList.map({ (list) -> HourlyWeatherItem in
            let temp = list.main.temp
            let date = list.dtTxt
            let iconName = list.weather[0].icon
            return HourlyWeatherItem(iconName: iconName, temperature: temp, date: date)
        })
    }
    
    func saveDailyWeatherItems(from data: Weather) {
        let maxCount = data.list.count > maxItemCount ? maxItemCount : data.list.count
        dailyWeatherItems = data.list[0...maxCount].map({ (list) -> DailyWeatherItem in
            let max = list.main.tempMax
            let min = list.main.tempMin
            let date = list.dtTxt
            let iconName = list.weather[0].icon
            return DailyWeatherItem(iconName: iconName, date: date, maxTemperature: max, minTemperature: min)
        })
        
    }
    
    func updateWeatherLabels() {
        self.dailyTableView.reloadData()
        self.hourlyCollectionView.reloadData()
        self.cityLabel.text = currentWeather.city
        self.condionLabel.text = currentWeather.condition
        self.temperatureLabel.text = currentWeather.temperatureText
        self.weatherIconImageView.image = currentWeather.icon
    }
}

extension ViewController: CLLocationManagerDelegate {
    // when it's done updating current location of device
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //when locationManager finds location information
        // 마지막 element가 가장 정확도가 높은 위치
        let location = locations[locations.count-1]
        // stop updating when you got a valid result
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let coordinatePair = location.coordinate.getCoordinatePair()
            print("\(coordinatePair)")
            getWeatherData(using: coordinatePair)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyWeatherItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else {
            return HourlyCollectionViewCell()
        }
        let weatherItem = hourlyWeatherItems[indexPath.row]
        cell.temperatureLabel.text = weatherItem.temperatureText
        cell.hourLabel.text = weatherItem.dateText
        cell.weatherIconImageView.image = weatherItem.icon
        return cell
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyWeatherItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dailyTableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as? DailyTableViewCell else {
            return DailyTableViewCell()
        }
        let weatherItem = dailyWeatherItems[indexPath.row]
        cell.weatherIconImageView.image = weatherItem.icon
        cell.dayLabel.text = weatherItem.dateText
        cell.maxMinTemperatureLabel.text = weatherItem.temperatureText
        return cell
    }
}
