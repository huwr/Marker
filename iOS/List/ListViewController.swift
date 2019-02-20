//
//  MasterViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UITableViewController {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? { didSet {
        tableView.reloadData()
    }}

    var database: MarkerDatabase? { didSet {
        self.markers = database?.all()
    }}
    var markers: [Marker]?

    var showingClosest: Bool { return searchBarIsEmpty && currentLocation != nil }

    private func marker(for row: Int) -> Marker? {
        guard showingClosest, let currentLocation = currentLocation else { return markers?[row] }

        if row == 0 {
            return database?.closestTo(location: currentLocation)
        }
        return markers?[row - 1]
    }

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "KCT024"
        searchController.searchBar.accessibilityLabel = "Search by ID, locality or environment."
        searchController.searchBar.tintColor = UIColor.white

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true

        tableView.estimatedRowHeight = 60

        self.startUpdatingLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail",
            let indexPath = tableView.indexPathForSelectedRow,
            let object = marker(for: indexPath.row) else { return }

        if let markerVC = (segue.destination as? UINavigationController)?.topViewController as? MarkerViewController {
            markerVC.marker = object
            markerVC.location = currentLocation
            markerVC.navigationItem.title = object.markerId
            markerVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            markerVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markers?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let cell = cell as? ListTableViewCell,
            let marker = marker(for: indexPath.row) {

            cell.isClosest = showingClosest && indexPath.row == 0
            cell.title = "\(marker.markerId)"
            cell.detail = marker.locationDescription
            cell.distance = marker.distance(from: currentLocation)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }

    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            markers = database?.all()
        } else {
            markers = database?.with(keyword: searchText.uppercased())
        }
        tableView.reloadData()
    }
}

extension ListViewController: CLLocationManagerDelegate {
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 20
            locationManager.startUpdatingLocation()

            print("start updating location…")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated!")
        if let lastLocation = locations.last {
            self.currentLocation = lastLocation
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
