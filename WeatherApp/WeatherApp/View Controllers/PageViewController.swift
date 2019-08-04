//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 05/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    var mainStroryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    var pageControl = UIPageControl()
    var locationList: [Coordinate] = [Coordinate(lat: "37.5665", lon: "126.978"), Coordinate(lat: "51.5074", lon: "0.1278")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        configurePageControl()
        let weatherViewController = mainStroryboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherViewController.coordinate = locationList[0]
        self.setViewControllers([weatherViewController], direction: .forward, animated: false, completion: {done in })
    }

    private func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = locationList.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    // MARK: Delegate methods
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
    // MARK: - Page View Controller Data Source
    
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
