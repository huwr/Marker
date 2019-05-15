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

    @IBOutlet private var directionsContainerView: UIView?
    @IBOutlet private var directionsView: UITextView?
    @IBOutlet private var showInstructionsButton: UIBarButtonItem?
    @IBOutlet private var showMoreInfoButton: UIBarButtonItem?
    @IBOutlet private var mapView: MKMapView?
    @IBOutlet private var mapStyle: UISegmentedControl?
    @IBOutlet private var tapSearchPrompt: UILabel?

    var sharer: MarkerSharer {
        var sharer = MarkerSharer(viewController: self)
        sharer.marker = marker
        return sharer
    }

    var marker: Marker?

    var location: CLLocation?

    // MARK: Directions

    var directionsHidden: Bool = true { didSet {
        showInstructionsButton?.title = directionsHidden ? "Show Instructions" : "Hide Instructions"
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
        showInstructionsButton?.isEnabled = !mapHidden
        showMoreInfoButton?.isEnabled = !mapHidden
        mapStyle?.isHidden = mapHidden
        mapView?.isHidden = mapHidden
        tapSearchPrompt?.isHidden = !mapHidden
    } }

    private func configureMapView() {
        guard let marker = marker else {
            mapHidden = true
            return
        }
        mapHidden = false

        directionsView?.text = marker.localizedInstructions

        let coordinateRegion = MKCoordinateRegion.init(center: marker.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)

        mapView?.addAnnotation(marker.pointAnnotation)
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
        mapView?.isAccessibilityElement = false
        configureView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMoreInfo", let destinationNC = segue.destination as? UINavigationController,
            let moreInfoVC = destinationNC.viewControllers.first as? MoreInfoViewController {
            moreInfoVC.currentLocation = location
            moreInfoVC.marker = marker
        }
    }

    // MARK: Action

    @objc func actionPressed(_ sender: UIBarButtonItem) {
        sharer.presentMapsDialog(sender)
    }
}
