//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 04/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {
    static let identifier = "LocationListViewController"
    let cities = ["London", "Paris", "Seoul"]

    @IBOutlet weak var locationListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationListTableView.delegate = self
        self.locationListTableView.dataSource = self
    }
}

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath)
        if indexPath.row == cities.count {
            cell.textLabel?.text = "+"
        } else {
            cell.textLabel?.text = cities[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == cities.count {
            presentSearchViewController()
        }
    }
    
    private func presentSearchViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchVC")
        self.present(nextVC, animated: true, completion: nil)
    }
}
