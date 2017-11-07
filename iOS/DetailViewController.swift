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

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func directionsPressed(_ sender: Any) {
        guard let targetLocation = marker?.coordinate else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: targetLocation))
        mapItem.name = marker?.markerId
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    var marker: Marker? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        guard let marker = marker else { return }

        detailDescriptionLabel?.text = marker.description

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(marker.coordinate, regionRadius, regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)

        mapView?.addAnnotation(marker)
    }

    let regionRadius: CLLocationDistance = 1000

    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }

}
