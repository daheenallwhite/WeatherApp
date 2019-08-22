//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 04/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {
    @IBOutlet weak var locationListTableView: UITableView!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var temperatureSwitch: UISwitch!
    
    static let identifier = "LocationListViewController"
    private let defaults = UserDefaults.standard
    var locations = [Location]()
    weak var delegate: LocationListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationListTableView.delegate = self
        self.locationListTableView.dataSource = self
        self.temperatureSwitch.isOn = TemperatureUnit.shared.boolValue
    }
    
    @IBAction func addLocationButtonTouched(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searcheViewController = mainStoryboard.instantiateViewController(withIdentifier: SearchViewController.identifier) as? SearchViewController else {
            print(CreationError.toSearchViewController)
            return
        }
        searcheViewController.delegate = self
        self.present(searcheViewController, animated: true, completion: nil)
    }
    
    @IBAction func temperatureSwitchValueChanged(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: DataKeys.temperatureUnit)
        TemperatureUnit.shared.setUnit(with: sender.isOn)
    }
    
}

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.userDidSelectLocation(at: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let cellType = LocationListCellType(rowIndex: indexPath.row) else {
            return false
        }
        return cellType.canEditRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath)
        guard let cellType = LocationListCellType(rowIndex: indexPath.row) else {
            return cell
        }
        cell.textLabel?.text = cellType.defaultText ?? self.locations[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locations.remove(at: indexPath.row)
            defaults.set(locations.count - 1, forKey: DataKeys.locationCount)
            if self.locations.count > 1 {
                let savingList = Array(locations[1...locations.count - 1])
                defaults.setLocations(savingList, forKey: DataKeys.locations)
            } else {
                defaults.removeObject(forKey: DataKeys.locations)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.userDeleteLocation(at: indexPath.row)
        }
    }
}

extension LocationListViewController: SearchViewDelegate {
    func userAdd(newLocation: Location) {
        self.locations.append(newLocation)
        let savingList = Array(locations[1...locations.count - 1])
        defaults.setLocations(savingList, forKey: DataKeys.locations)
        defaults.set(savingList.count, forKey: DataKeys.locationCount)
        self.delegate?.userAdd(newLocation: newLocation)
        self.locationListTableView.reloadData()
    }
}

