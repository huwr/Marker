//
//  DetailViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var directionsView: UITextView?
    @IBOutlet weak var showDirectionsButton: UIBarButtonItem?
    @IBOutlet weak var mapView: MKMapView?

    var marker: MarkerProtocol? { didSet {
            configureView()
    } }

    // MARK: Directions

    var directionsHidden: Bool = true { didSet {
        showDirectionsButton?.title = directionsHidden ? "Show Directions" : "Hide Directions"
        directionsView?.isHidden = directionsHidden
    } }

    @IBAction func showDirectionsTapped(_ sender: UIBarButtonItem) {
        directionsHidden = !directionsHidden
    }

    // MARK: Map

    var mapHidden: Bool = true { didSet {
        navigationItem.rightBarButtonItem?.isEnabled = !mapHidden
        showDirectionsButton?.isEnabled = !mapHidden
        mapView?.isHidden = mapHidden
    } }

    func configureMapView() {
        guard let marker = marker else {
            mapHidden = true
            return
        }
        mapHidden = false

        directionsView?.text = marker.localizedDirections

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(marker.coordinate, regionRadius, regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)

        mapView?.addAnnotation(marker)
    }

    @objc func navigatePressed(_ sender: Any) {
        guard let marker = marker else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: marker.coordinate))
        mapItem.name = marker.markerId
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    let regionRadius: CLLocationDistance = 1000

    // MARK: View lifecycle

    func configureView() {
        navigationItem.largeTitleDisplayMode = .never
        configureMapView()
    }

    override func viewDidLoad() {
        let navigateButton = UIBarButtonItem(title: "Open in Maps…", style: .plain, target: self, action: #selector(navigatePressed(_:)))
        navigationItem.rightBarButtonItem = navigateButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        mapView?.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
}
