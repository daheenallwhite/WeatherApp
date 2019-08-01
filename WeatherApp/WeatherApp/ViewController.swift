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
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation() //Asynchronous
        // didUpdataLocation <- when it's done updating
    }
    
    func getQueryItems(latitude: String, longtitude: String) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let latitudeQuery = URLQueryItem(name: "lat", value: latitude)
        let longtitudeQuery = URLQueryItem(name: "lon", value: longtitude)
        let appIdQuery = URLQueryItem(name: "APPID", value: WeatherAPI.appID)
        queryItems.append(contentsOf: [latitudeQuery, longtitudeQuery, appIdQuery])
        return queryItems
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
            
            
        }
    }
}
