//
//  MasterViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import CoreLocation

protocol MarkerSelectionDelegate: class {
    func select(_ marker: Marker)
    var location: CLLocation? { get set }
    var allMarkers: [Marker]? { get set }
}

class ListViewController: UITableViewController, ListSelectionDelegate {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? { didSet {
        tableView.reloadData()
    }}

    var database: MarkerDatabase? { didSet {
        self.markers = database?.all()
    }}
    var markers: [Marker]?

    var showingClosest: Bool { return searchBarIsEmpty && currentLocation != nil }

    weak var delegate: MarkerSelectionDelegate?

    private func marker(for row: Int) -> Marker? {
        guard showingClosest, let currentLocation = currentLocation else { return markers?[row] }

        if row == 0 {
            return database?.closestTo(location: currentLocation)
        }
        return markers?[row - 1]
    }

    private func row(for marker: Marker) -> Int? {
        guard let index = markers?.firstIndex(where: { marker.markerId == $0.markerId }) else {
            return nil
        }
        return index + 1
    }

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor.init(named: "AppBlue")

            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.hidesSearchBarWhenScrolling = false
        }

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "KCT024"
        searchController.searchBar.accessibilityLabel = "Search by ID, locality or environment."
        searchController.searchBar.tintColor = UIColor.white

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])

        navigationItem.searchController = searchController

        definesPresentationContext = true

        tableView.estimatedRowHeight = 60

        self.startUpdatingLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Movement

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedMarker = marker(for: indexPath.row) else {
            return
        }

        delegate?.select(selectedMarker)
        delegate?.allMarkers = markers
        delegate?.location = currentLocation

        if let markerViewController = delegate as? MarkerViewController,
            let markerNavigationController = markerViewController.navigationController {
            splitViewController?.showDetailViewController(markerNavigationController, sender: nil)
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
            let isClosest = showingClosest && indexPath.row == 0

            cell.configure(with: marker, isClosest: isClosest, distance: marker.distance(from: currentLocation))
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: ListSelectionDelegate

    func didSelect(_ marker: Marker?) {
        guard let marker = marker,
            let row = row(for: marker) else {
                return
        }
        let indexPath = IndexPath(row: row, section: 0)

        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
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
