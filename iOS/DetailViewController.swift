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

    @IBOutlet weak var directionsContainerView: UIView?
    @IBOutlet weak var directionsView: UITextView?
    @IBOutlet weak var showDirectionsButton: UIBarButtonItem?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var mapStyle: UISegmentedControl?

    var marker: MarkerProtocol? { didSet {
        configureView()
    } }

    // MARK: Directions

    var directionsHidden: Bool = true { didSet {
        showDirectionsButton?.title = directionsHidden ? "Show Directions" : "Hide Directions"
        directionsContainerView?.isHidden = directionsHidden
    } }

    @IBAction func showDirectionsTapped(_ sender: UIBarButtonItem) {
        directionsHidden = !directionsHidden
    }

    // MARK: Map

    var mapHidden: Bool = true { didSet {
        navigationItem.rightBarButtonItem?.isEnabled = !mapHidden
        showDirectionsButton?.isEnabled = !mapHidden
        mapStyle?.isHidden = mapHidden
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

    // MARK: Map Style

    @IBAction func mapStyleChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView?.mapType = .standard
        default:
            mapView?.mapType = .hybrid
        }
    }

    // MARK: View lifecycle

    func configureView() {
        navigationItem.largeTitleDisplayMode = .never
        configureMapView()

        if let directionsContainerView = directionsContainerView, let directionsView = directionsView {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = directionsContainerView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            directionsContainerView.insertSubview(blurEffectView, belowSubview: directionsView)
        }

        //MapStyle segment control
        mapStyle?.backgroundColor = .white
        mapStyle?.layer.cornerRadius = 4.0
        mapStyle?.clipsToBounds = true
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
