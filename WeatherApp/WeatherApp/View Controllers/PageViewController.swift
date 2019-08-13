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
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let mainStroryboard = UIStoryboard(name: "Main", bundle: nil)
    private var pageControl = UIPageControl()
    private var locationManager = LocationManager()
    private var cachedWeatherViewControllers = NSCache<NSNumber, WeatherViewController>()
    private var userLocationList = [Location](){
        didSet {
            self.pageControl.numberOfPages = userLocationList.count
        }
    }
    var lastViewedPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSavedDataInUserDefaults()
        configureSubViews()
        print(userLocationList)
        self.view.backgroundColor = .clear
        self.locationManager.delegate = self
        self.locationManager.requestCurrentLocation()
    }
    
    private func setSavedDataInUserDefaults() {
        self.userLocationList = defaults.locationArray(Location.self, forKey: DataKeys.locations)
        let savedLocationCount = defaults.integer(forKey: DataKeys.locationCount)
        let savedLastViewedIndex = defaults.integer(forKey: DataKeys.lastViewedPage)
        self.lastViewedPageIndex = savedLocationCount >= savedLastViewedIndex ? savedLastViewedIndex : 0
    }
    
    private func configureSubViews() {
        let pageViewFrame = self.view.frame
        configurePageViewController(inside: pageViewFrame)
        configurePageControl(inside: pageViewFrame)
        configureListButton(inside: pageViewFrame)
    }
    
    private func configurePageViewController(inside frame: CGRect) {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        let weatherViewRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 50)
        self.pageViewController.view.frame = weatherViewRect
        self.pageViewController.didMove(toParent: self)
    }
    
    private func configurePageControl(inside frame: CGRect) {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: frame.maxY - 50, width: frame.maxX, height: 50))
        self.pageControl.numberOfPages = defaults.integer(forKey: DataKeys.locationCount) + 1
        self.pageControl.currentPage = lastViewedPageIndex
        self.pageControl.tintColor = .gray
        self.pageControl.pageIndicatorTintColor = .gray
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.backgroundColor = .clear
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(self.changeCurrentPageViewController), for: .valueChanged)
    }
    
    func configureListButton(inside frame: CGRect) {
        let buttonRect = CGRect(x: frame.maxX - 50, y: frame.maxY - 40, width: 20, height: 20)
        let locationListButton = UIButton(frame: buttonRect)
        locationListButton.setImage(UIImage(named: "list-icon"), for: .normal)
        locationListButton.addTarget(self, action: #selector(self.presentLocationListViewController), for: .touchUpInside)
        self.view.addSubview(locationListButton)
    }
    
    @objc func changeCurrentPageViewController() {
        print("tapped at \(self.pageControl.currentPage)")
        lastViewedPageIndex = self.pageControl.currentPage
        let pickedViewController = weatherViewController(at: self.pageControl.currentPage)
        self.pageViewController.setViewControllers([pickedViewController], direction: .forward, animated: false, completion: nil)
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
    func locationManagerDidUpdate(currentLocation: Location) {
        self.userLocationList.insert(currentLocation, at: 0)
        let currentWeatherViewController = weatherViewController(at: lastViewedPageIndex)
        self.pageViewController.setViewControllers([currentWeatherViewController], direction: .forward, animated: false, completion: nil)
    }
}

//MARK: page view controller delegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let displayedContentViewController = pageViewController.viewControllers?[0] as? WeatherViewController else {
            return
        }
        self.pageControl.currentPage = displayedContentViewController.index
        self.lastViewedPageIndex = displayedContentViewController.index
    }
}


//MARK: page view controller data source
extension PageViewController: UIPageViewControllerDataSource {
    func weatherViewController(at index: Int) -> UIViewController {
        if let cachedWeatherViewController = cachedWeatherViewControllers.object(forKey: NSNumber(value: index)) {
            return cachedWeatherViewController
        }
        guard let createdWeatherViewController = mainStroryboard.instantiateViewController(withIdentifier: WeatherViewController.identifier) as? WeatherViewController else {
            CreationError.toWeatherViewController.andReturn()
        }
        createdWeatherViewController.location = userLocationList[index]
        createdWeatherViewController.index = index
        cachedWeatherViewControllers.setObject(createdWeatherViewController, forKey: NSNumber(value: index))
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
            print(CreationError.toWeatherViewController)
            return
        }
        self.pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = index
        self.lastViewedPageIndex = index
    }
    
    func userAdd(newLocation: Location) {
        self.userLocationList.append(newLocation)
    }
    
    func userDeleteLocation(at deletingIndex: Int) {
        print("page vc delete location at index \(deletingIndex)")
        if self.lastViewedPageIndex == deletingIndex {
            self.lastViewedPageIndex = 0
        }
        if self.lastViewedPageIndex > deletingIndex {
            self.lastViewedPageIndex -= 1
        }
        if isLastLocationInList(index: deletingIndex) {
            removeLocation(at: deletingIndex)
            return
        }
        removeLocation(at: deletingIndex)
        changeIndexOfCachedWeatherViewControllers(after: deletingIndex)
    }
    
    private func isLastLocationInList(index: Int) -> Bool {
        return index == userLocationList.count - 1
    }
    
    private func removeLocation(at index: Int) {
        self.userLocationList.remove(at: index)
        self.cachedWeatherViewControllers.removeObject(forKey: NSNumber(value: index))
    }
    
    private func changeIndexOfCachedWeatherViewControllers(after deletingIndex: Int) {
        var needChangeIndex = deletingIndex + 1
        repeat {
            let targetIndex = NSNumber(value: needChangeIndex)
            if let indexChangingViewController = self.cachedWeatherViewControllers.object(forKey: targetIndex) {
                self.cachedWeatherViewControllers.removeObject(forKey: targetIndex)
                indexChangingViewController.index -= 1
                self.cachedWeatherViewControllers.setObject(indexChangingViewController, forKey: NSNumber(value: indexChangingViewController.index))
            }
            needChangeIndex += 1
        } while needChangeIndex <= userLocationList.count
    }
}
