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
    var marker: MarkerProtocol?

    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    private func openInMaps() {
        guard let marker = marker else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: marker.coordinate))
        mapItem.name = marker.markerId
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    func presentMapsDialog() {
        guard let marker = marker else { return }

        let alert = UIAlertController(title: "Open in Maps app?", message: "This will open the marker '\(marker.markerId)' in the Maps app.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.openInMaps() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        viewController?.present(alert, animated: true, completion: nil)
    }

    func presentShareDialog() {
        guard let marker = marker else { return }
        let activityViewController = UIActivityViewController(activityItems: [marker.sharingDescription], applicationActivities: nil)
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}
