//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 04/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

protocol LocationListViewDelegate {
    func userDidSelectLocation(at index: Int)
    func userAdd(newLocation: Location)
    func userDeleteLocation(at index: Int)
}

class LocationListViewController: UIViewController {
    @IBOutlet weak var locationListTableView: UITableView!
    
    static let identifier = "LocationListViewController"
    private let defaults = UserDefaults.standard
    var locations = [Location]()
    var delegate: LocationListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationListTableView.delegate = self
        self.locationListTableView.dataSource = self
    }
}

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == locations.count else {
            self.delegate?.userDidSelectLocation(at: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(indexPath.row == self.locations.count || indexPath.row == 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath)
        if indexPath.row == locations.count {
            cell.textLabel?.text = "+"
            return cell
        }
        if indexPath.row == 0 {
            cell.textLabel?.text = "Current Location"
            return cell
        }
        cell.textLabel?.text = locations[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locations.remove(at: indexPath.row)
            let sublist = Array(locations[1...locations.count - 1])
            defaults.setLocations(sublist, forKey: "Locations")
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.userDeleteLocation(at: indexPath.row)
        }
    }
}

extension LocationListViewController: SearchViewDelegate {
    func userAdd(newLocation: Location) {
        self.locations.append(newLocation)
        let sublist = Array(locations[1...locations.count - 1])
        defaults.setLocations(sublist, forKey: "Locations")
        self.delegate?.userAdd(newLocation: newLocation)
        self.locationListTableView.reloadData()
    }
}


