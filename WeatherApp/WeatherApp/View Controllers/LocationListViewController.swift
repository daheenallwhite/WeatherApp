//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 04/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {
    var testData = [Location(coordinate: Coordinate(lat: "37.5665", lon: "126.978"), name: "Seoul"), Location(coordinate: Coordinate(lat: "40.7128", lon: "74.0060"), name: "New York")]
    
    
    static let identifier = "LocationListViewController"
    let defaults = UserDefaults.standard
    
    var locations = [Location]()
    

    @IBOutlet weak var locationListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        defaults.setLocations(testData, forKey: "Locations")
        locations = defaults.locationArray(Location.self, forKey: "Locations")
        
        self.locationListTableView.delegate = self
        self.locationListTableView.dataSource = self
    }
    
}

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == locations.count else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        presentSearchViewController()
    }
    
    private func presentSearchViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searcheViewController = mainStoryboard.instantiateViewController(withIdentifier: SearchViewController.identifier) as? SearchViewController else {
            print(CreationError.downcastingError(SearchViewController.identifier))
            return
        }
        searcheViewController.delegate = self
        self.present(searcheViewController, animated: true, completion: nil)
    }
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath)
        if indexPath.row == locations.count {
            cell.textLabel?.text = "+"
            return cell
        }
        cell.textLabel?.text = locations[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locations.remove(at: indexPath.row)
            defaults.setLocations(locations, forKey: "Locations")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension LocationListViewController: SearchViewDelegate {
    func userSelectNew(location: Location) {
        self.locations.append(location)
        defaults.setLocations(locations, forKey: "Locations")
        self.locationListTableView.reloadData()
    }
}


