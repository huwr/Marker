//
//  ActionController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 11/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import MapKit

struct MarkerSharer {
    var marker: Marker?

    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    private func openInAppleMaps() {
        guard let marker = marker else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: marker.coordinate))
        mapItem.name = marker.markerId
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    func presentMapsDialog(_ sender: UIBarButtonItem) {
        guard let marker = marker else { return }

        let alert = UIAlertController(title: "Open in Maps app?", message: "Do you want to open the marker '\(marker.markerId)' inside a Maps app?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default, handler: { _ in self.openInAppleMaps() }))
        if canOpenGoogleMaps {
            alert.addAction(UIAlertAction(title: "Open in Google Maps", style: .default, handler: { _ in self.openInGoogleMaps() }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.popoverPresentationController?.barButtonItem = sender

        viewController?.present(alert, animated: true, completion: nil)
    }

    func presentShareDialog(sender: UIBarButtonItem?) {
        guard let marker = marker else { return }
        let activityViewController = UIActivityViewController(activityItems: [marker.sharingDescription], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}

extension MarkerSharer {
    var canOpenGoogleMaps: Bool {
        guard let testUrl = URL(string: "comgooglemaps://") else { return false }
        return UIApplication.shared.canOpenURL(testUrl)
    }

    func openInGoogleMaps() {
        if let coords = marker?.coordinate {
            openInGoogleMaps(coords)
        }
    }

    func openInGoogleMaps(_ location: CLLocationCoordinate2D) {
        let latlong = "\(location.latitude),\(location.longitude)"
        let str = "comgooglemaps://?daddr=\(latlong)&zoom=14&views=traffic&directionsMode=driving"
        if let url = URL(string: str) {
            UIApplication.shared.open(url)
        }
    }
}
