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
        configureLocationListButton()
        setViewControllersForPageViewController(index: 0)
    }
    
    private func configurePageViewController() {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        let pageViewRect = self.view.bounds
        let weatherViewRect = CGRect(x: 0, y: 0, width: pageViewRect.width, height: pageViewRect.height - 50)
        self.pageViewController.view.frame = weatherViewRect
        self.pageViewController.didMove(toParent: self)
    }

    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = locationList.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = .gray
        self.pageControl.pageIndicatorTintColor = .gray
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.backgroundColor = .clear
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(self.changeCurrentPageViewController), for: .valueChanged)
    }
    
    private func configureLocationListButton() {
        let buttonRect = CGRect(x: UIScreen.main.bounds.maxX - 50, y: UIScreen.main.bounds.maxY - 40, width: 20, height: 20)
        let locationListButton = UIImageView(frame: buttonRect)
        locationListButton.image = UIImage(named: "list-icon")
        locationListButton.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(goToLocationList))
        singleTap.numberOfTapsRequired = 1
        locationListButton.addGestureRecognizer(singleTap)
        self.view.addSubview(locationListButton)
    }
    
    
    private func setViewControllersForPageViewController(index: Int) {
        let weatherViewController = mainStroryboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherViewController.coordinate = locationList[index]
        self.pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: false, completion: {done in })
    }
    
    @objc func changeCurrentPageViewController() {
        setViewControllersForPageViewController(index: self.pageControl.currentPage)
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

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! WeatherViewController
        self.pageControl.currentPage = locationList.firstIndex(of: pageContentViewController.coordinate!) ?? 0
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    private func viewControllerAtIndex(_ index: Int) -> WeatherViewController? {
        if (self.locationList.count == 0) || (index >= self.locationList.count) {
            return nil
        }
        let weatherViewController = mainStroryboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherViewController.coordinate = self.locationList[index]
        return weatherViewController
    }
    private func indexOfViewController(_ viewController: WeatherViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return locationList.firstIndex(of: viewController.coordinate!) ?? NSNotFound
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! WeatherViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! WeatherViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.locationList.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    

}
