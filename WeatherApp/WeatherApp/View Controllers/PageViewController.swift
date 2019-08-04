//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 05/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var pageControl = UIPageControl()
    var mainStroryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    var locationList: [Coordinate] = [Coordinate(lat: "37.5665", lon: "126.978"), Coordinate(lat: "51.5074", lon: "0.1278"), Coordinate(lat: "51.5001524", lon: "-0.1262362")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        configurePageViewController()
        configurePageControl()
        setViewControllersForPageViewController()
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
    }
    
    private func setViewControllersForPageViewController() {
        let weatherViewController = mainStroryboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherViewController.coordinate = locationList[0]
        self.pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: false, completion: {done in })
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
