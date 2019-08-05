//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 05/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit
import CoreLocation

class PageViewController: UIViewController {
    let defaults = UserDefaults.standard
    let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var pageControl = UIPageControl()
    var mainStroryboard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
    let locationManager = CLLocationManager()
    var didUpdatCurrentLocation: Bool = false
    var userLocationList = [Location](){
        didSet {
            self.pageControl.numberOfPages = userLocationList.count
        }
    }
    
    var cachedWeatherViewControllers = [Int: WeatherViewController]()
    
    var testData = [Location(coordinate: Coordinate(lat: "37.5665", lon: "126.978"), name: "Seoul"), Location(coordinate: Coordinate(lat: "43.000351", lon: "-75.499901"), name: "New York"), Location(coordinate: Coordinate(lat: "15.3525", lon: "120.832703"), name: "San Francisco")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLocationList = defaults.locationArray(Location.self, forKey: "Locations")
        print(userLocationList)
        self.view.backgroundColor = .clear
        
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        configurePageViewController()
        configurePageControl()
        configureListButton()
    }
    
    func configurePageViewController() {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        let safeAreaRect = self.view.safeAreaLayoutGuide.layoutFrame
        let weatherViewRect = CGRect(x: 0, y: 0, width: safeAreaRect.width, height: safeAreaRect.height - 50)
        self.pageViewController.view.frame = weatherViewRect
        self.pageViewController.didMove(toParent: self)
    }
    
    func configurePageControl() {
        let safeAreaRect = self.view.safeAreaLayoutGuide.layoutFrame
        pageControl = UIPageControl(frame: CGRect(x: 0,y: safeAreaRect.maxY - 50,width: safeAreaRect.maxX, height: 50))
        self.pageControl.numberOfPages = userLocationList.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = .gray
        self.pageControl.pageIndicatorTintColor = .gray
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.backgroundColor = .clear
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(self.changeCurrentPageViewController), for: .valueChanged)
    }
    
    func configureListButton() {
        let safeAreaRect = self.view.safeAreaLayoutGuide.layoutFrame
        let buttonRect = CGRect(x: safeAreaRect.maxX - 50, y: safeAreaRect.maxY - 40, width: 20, height: 20)
        let locationListButton = UIImageView(frame: buttonRect)
        locationListButton.image = UIImage(named: "list-icon")
        locationListButton.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(goToLocationList))
        singleTap.numberOfTapsRequired = 1
        locationListButton.addGestureRecognizer(singleTap)
        self.view.addSubview(locationListButton)
    }
    
    @objc func changeCurrentPageViewController() {
        let pickedViewController = weatherViewController(at: self.pageControl.currentPage)
        self.pageViewController.setViewControllers([pickedViewController], direction: .forward, animated: false, completion: {done in })
    }
    
    @objc func goToLocationList() {
        let locationListViewController = storyboard?.instantiateViewController(withIdentifier: LocationListViewController.identifier)
        self.present(locationListViewController!, animated: true, completion: nil)
    }
}

//MARK: location manager delegate
extension PageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let currentLocation = Location(coordinate: Coordinate(coordinate: location.coordinate))
            print("\(currentLocation)")
            if didUpdatCurrentLocation { // for preventing creation of current weather view more than twice
                return
            }
            didUpdatCurrentLocation.toggle()
            self.userLocationList.insert(currentLocation, at: 0)
            let firstViewController = weatherViewController(at: 0)
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: {done in })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

//MARK: page view controller delegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! WeatherViewController
        self.pageControl.currentPage = pageContentViewController.index
    }
}


//MARK: page view controller data source
extension PageViewController: UIPageViewControllerDataSource {
    func weatherViewController(at index:Int) -> UIViewController {
        if let cachedPageViewController = cachedWeatherViewControllers[index] {
            return cachedPageViewController
        }
        guard let pageViewController = mainStroryboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            fatalError("WeatherViewcontroller....error")
        }
        pageViewController.location = userLocationList[index]
        pageViewController.index = index
        cachedWeatherViewControllers[index] = pageViewController
        return pageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? WeatherViewController {
            let currentIndex = viewController.index
            return currentIndex > 0 ? weatherViewController(at: currentIndex - 1) : nil
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? WeatherViewController {
            let currentIndex = viewController.index
            return currentIndex < pageControl.numberOfPages - 1 ? weatherViewController(at: currentIndex + 1) : nil
        }
        return nil
    }

}

