//
//  DetailViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import MapKit

class MarkerViewController: UIViewController {

    @IBOutlet var directionsContainerView: UIView?
    @IBOutlet var directionsView: UITextView?
    @IBOutlet var showDirectionsButton: UIBarButtonItem?
    @IBOutlet var showMoreInfoButton: UIBarButtonItem?
    @IBOutlet var mapView: MKMapView?
    @IBOutlet var mapStyle: UISegmentedControl?

    var sharer: MarkerSharer?

    var marker: MarkerProtocol? { didSet {
        configureView()

        sharer = MarkerSharer(viewController: self)
        sharer?.marker = marker
    } }

    var location: CLLocation?

    // MARK: Directions

    var directionsHidden: Bool = true { didSet {
        showDirectionsButton?.title = directionsHidden ? "Show Directions" : "Hide Directions"
        directionsView?.flashScrollIndicators()
        directionsView?.setContentOffset(.zero, animated: true)
        directionsContainerView?.isHidden = directionsHidden
    } }

    @IBAction func showDirectionsTapped(_ sender: UIBarButtonItem) {
        directionsHidden = !directionsHidden
    }

    // MARK: Map

    var mapHidden: Bool = true { didSet {
        navigationItem.rightBarButtonItem?.isEnabled = !mapHidden
        showDirectionsButton?.isEnabled = !mapHidden
        showMoreInfoButton?.isEnabled = !mapHidden
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
        super.viewDidLoad()
        let navigateButton = UIBarButtonItem(title: "Open Maps…", style: .plain, target: self, action: #selector(actionPressed(_:)))
        navigationItem.rightBarButtonItem = navigateButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        mapView?.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMoreInfo", let destinationNC = segue.destination as? UINavigationController,
            let moreInfoVC = destinationNC.viewControllers.first as? MoreInfoViewController {
            moreInfoVC.location = location
            moreInfoVC.marker = marker
        }
    }

    // MARK: Action

    @objc func actionPressed(_ sender: Any) {
        sharer?.presentMapsDialog()
    }
}
