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
    
    func saveResponse(from data: Data) {
        do {
            guard let reponseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
                return
            }
            self.response = reponseDictionary
            print(self.response)
        } catch let parseError as NSError {
            print("JSONSerialization error: \(parseError.localizedDescription)\n")
            return
        }
        updateWeatherLabels()
    }
    
    func updateWeatherLabels() {
        self.cityLabel.text = response["name"] as? String
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
            
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            print("longitude = \(longtitude), latitude = \(latitude)")
            
            getWeatherData(latitude: latitude, longtitude: longtitude)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else {
            return HourlyCollectionViewCell()
        }
        cell.temperatureLabel.text = "self"
        cell.hourLabel.text = "3AM"
        cell.weatherIconImageView.image = icons[indexPath.row]
        return cell
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dailyTableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as? DailyTableViewCell else {
            return DailyTableViewCell()
        }
        cell.weatherIconImageView.image = icons[indexPath.row]
        cell.dayLabel.text = "Monday"
        cell.maxMinTemperatureLabel.text = "34  25"
        return cell
    }
}
