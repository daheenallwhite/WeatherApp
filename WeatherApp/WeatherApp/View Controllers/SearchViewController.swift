//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Daheen Lee on 03/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    static let identifier = "SearchViewController" 
    private let searchTableCellIdentifier = "searchResultCell"
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchResultTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: SearchViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchBar()
        setUpSearchCompleter()
        setUpSearchResultTable()
    }
    
    private func setUpSearchBar() {
        self.searchBar.showsCancelButton = true
        self.searchBar.becomeFirstResponder()
        self.searchBar.delegate = self
    }
    
    private func setUpSearchCompleter() {
        self.searchCompleter.delegate = self
        self.searchCompleter.filterType = .locationsOnly
    }
    
    private func setUpSearchResultTable() {
        self.searchResultTable.dataSource = self
        self.searchResultTable.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(LocationError.localSearchCompleterFail)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTable.dequeueReusableCell(withIdentifier: searchTableCellIdentifier, for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard error == nil else {
                print(LocationError.localSearchRequstFail)
                return
            }
            guard let placeMark = response?.mapItems[0].placemark else {
                return
            }
            let coordinate = Coordinate(coordinate: placeMark.coordinate)
            let locationName = "\(placeMark.locality ?? selectedResult.title)"
            self.delegate?.userAdd(newLocation: Location(coordinate: coordinate, name: locationName))
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
