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
    private let defaults = UserDefaults.standard
    private let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let mainStroryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var pageControl = UIPageControl()
    private var locationManager = LocationManager()
    private var cachedWeatherViewControllers = [Int: WeatherViewController]()
    private var userLocationList = [Location](){
        didSet {
            self.pageControl.numberOfPages = userLocationList.count
        }
    }
    var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLocationList = defaults.locationArray(Location.self, forKey: DataKeys.locations)
        self.currentPageIndex = defaults.integer(forKey: DataKeys.currentPage)
        configureSubViews()
        print(userLocationList)
        self.view.backgroundColor = .clear
        self.locationManager.delegate = self
        self.locationManager.requestCurrentLocation()
    }
    
    private func configureSubViews() {
        let screenMainBounds = UIScreen.main.bounds
        configurePageViewController(inside: screenMainBounds)
        configurePageControl(inside: screenMainBounds)
        configureListButton(inside: screenMainBounds)
    }
    
    private func configurePageViewController(inside bounds: CGRect) {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        let weatherViewRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 50)
        self.pageViewController.view.frame = weatherViewRect
        self.pageViewController.didMove(toParent: self)
    }
    
    private func configurePageControl(inside bounds: CGRect) {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: bounds.maxY - 50,width: bounds.maxX, height: 50))
        self.pageControl.numberOfPages = defaults.integer(forKey: DataKeys.locationCount) + 1
        self.pageControl.currentPage = currentPageIndex
        self.pageControl.tintColor = .gray
        self.pageControl.pageIndicatorTintColor = .gray
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.backgroundColor = .clear
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(self.changeCurrentPageViewController), for: .valueChanged)
    }
    
    func configureListButton(inside bounds: CGRect) {
        let buttonRect = CGRect(x: bounds.maxX - 50, y: bounds.maxY - 40, width: 20, height: 20)
        let locationListButton = UIImageView(frame: buttonRect)
        locationListButton.image = UIImage(named: "list-icon")
        locationListButton.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(presentLocationListViewController))
        singleTap.numberOfTapsRequired = 1
        locationListButton.addGestureRecognizer(singleTap)
        self.view.addSubview(locationListButton)
    }
    
    @objc func changeCurrentPageViewController() {
        print("tapped at \(self.pageControl.currentPage)")
        currentPageIndex = self.pageControl.currentPage
        let pickedViewController = weatherViewController(at: self.pageControl.currentPage)
        self.pageViewController.setViewControllers([pickedViewController], direction: .forward, animated: false, completion: {done in })
    }
    
    @objc func presentLocationListViewController() {
        guard let locationListViewController = mainStroryboard.instantiateViewController(withIdentifier: LocationListViewController.identifier) as? LocationListViewController else {
            return
        }
        locationListViewController.locations = self.userLocationList
        locationListViewController.delegate = self
        self.present(locationListViewController, animated: true, completion: nil)
    }
}

extension PageViewController: LocationManagerDelegate {
    func locationManagerDidUpdate(currenLocation: Location) {
        self.userLocationList.insert(currenLocation, at: 0)
        let currentWeatherViewController = weatherViewController(at: currentPageIndex)
        self.pageViewController.setViewControllers([currentWeatherViewController], direction: .forward, animated: false, completion: nil)
    }
}

//MARK: page view controller delegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let displayedContentViewController = pageViewController.viewControllers![0] as! WeatherViewController
        self.pageControl.currentPage = displayedContentViewController.index
    }
}


//MARK: page view controller data source
extension PageViewController: UIPageViewControllerDataSource {
    func weatherViewController(at index: Int) -> UIViewController {
        if let cachedWeatherViewController = cachedWeatherViewControllers[index] {
            return cachedWeatherViewController
        }
        guard let createdWeatherViewController = mainStroryboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            fatalError("WeatherViewcontroller....error")
        }
        createdWeatherViewController.location = userLocationList[index]
        createdWeatherViewController.index = index
        cachedWeatherViewControllers[index] = createdWeatherViewController
        return createdWeatherViewController
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

extension PageViewController: LocationListViewDelegate {
    func userDidSelectLocation(at index: Int) {
        guard let weatherViewController = weatherViewController(at: index) as? WeatherViewController else {
            return
        }
        self.pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = index
        currentPageIndex = index
    }
    
    func userAdd(newLocation: Location) {
        self.userLocationList.append(newLocation)
    }
    
    func userDeleteLocation(at index: Int) {
        print("page vc delete location at index \(index)")
        self.userLocationList.remove(at: index)
        self.cachedWeatherViewControllers.removeValue(forKey: index)
        var needChangeIndex = index + 1
        while let vc = cachedWeatherViewControllers[needChangeIndex] {
            vc.index = vc.index - 1
            cachedWeatherViewControllers[vc.index] = vc
            needChangeIndex += 1
        }
    }
    
    
}
