//
//  DetailViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import MapKit

protocol ListSelectionDelegate: AnyObject {
    func didSelect(_ marker: Marker?)
}

class MarkerViewController: UIViewController, MarkerSelectionDelegate {

    @IBOutlet private var directionsContainerView: UIView!
    @IBOutlet private var directionsView: UITextView!
    @IBOutlet private var showInstructionsButton: UIBarButtonItem!
    @IBOutlet private var showMoreInfoButton: UIBarButtonItem!
    @IBOutlet private var mapView: MKMapView?
    @IBOutlet private var mapStyle: UISegmentedControl!
    @IBOutlet private var tapSearchPrompt: UILabel!

    var sharer: MarkerSharer {
        var sharer = MarkerSharer(viewController: self)
        sharer.marker = selectedMarker
        return sharer
    }

    var selectedMarker: Marker? {
        didSet {
            directionsView?.text = selectedMarker?.localizedInstructions
            title = selectedMarker?.markerId
        }
    }

    var allMarkers: [Marker]? {
        didSet {
            configureMapView()
        }
    }

    var location: CLLocation?

    weak var delegate: ListSelectionDelegate?

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
        guard let marker = selectedMarker else {
            mapHidden = true
            mapView?.setRegion(MKCoordinateRegion.melbourne, animated: false)
            return
        }
        mapHidden = false

        let coordinateRegion = MKCoordinateRegion.init(center: marker.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)

        let annotations = allMarkers?.map { $0.pointAnnotation }
        if let annotations = annotations {
            mapView?.removeAnnotations(annotations)
            mapView?.addAnnotations(annotations)
        }

        mapView?.delegate = self
    }

    let regionRadius: CLLocationDistance = 1000 //metres

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
//        mapStyle?.backgroundColor = .white
//        mapStyle?.layer.cornerRadius = 4.0
//        mapStyle?.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigateButton = UIBarButtonItem(title: "Open Maps…", style: .plain, target: self, action: #selector(actionPressed(_:)))
        navigationItem.rightBarButtonItem = navigateButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        mapView?.isAccessibilityElement = false
        configureView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMoreInfo", let destinationNC = segue.destination as? UINavigationController,
            let moreInfoVC = destinationNC.viewControllers.first as? MoreInfoViewController {
            moreInfoVC.currentLocation = location
            moreInfoVC.marker = selectedMarker
        }
    }

    // MARK: Action

    @objc func actionPressed(_ sender: UIBarButtonItem) {
        sharer.presentMapsDialog(sender)
    }

    // MARK: MarkerSelectionDelegate

    func select(_ marker: Marker) {
        selectedMarker = marker
        configureView()
    }
}

extension MarkerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title ?? "" else {
            return
        }

        if let new = allMarkers?.first(where: { $0.markerId == title }) {
            selectedMarker = new

            delegate?.didSelect(selectedMarker)
        }
    }
}

private extension MKCoordinateRegion {
    static var melbourne: MKCoordinateRegion {
        let melbourne = CLLocationCoordinate2D(latitude: -37.8633, longitude: 144.9802)
        return MKCoordinateRegion(center: melbourne, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
}
