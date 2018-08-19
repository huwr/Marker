//
//  Marker.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 9/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol Marker {
    var latitude: Double { get set }

    var longitude: Double { get set }

    // CAD Directions
    var directions: String { get set }

    // Marker ID like KCT040
    var markerId: String { get set }

    //eg DONCASTER EAST
    var locality: String { get set }

    //eg MANNINGHAM CITY
    var environmentName: String { get set }

    var aRoadName: String { get set }
    var aRoadType: String { get set }
    var aRoadSuffix: String { get set }

    var bRoadName: String { get set }
    var bRoadType: String { get set }
    var bRoadSuffix: String { get set }

    //eg TURNTABLE CAR PARK
    var markerAddress: String { get set }
}

extension Marker {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        return CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    func distance(from origin: CLLocation?) -> Double? {
        guard let origin = origin else { return nil }
        return origin.distance(from: location)
    }

    var aRoad: String {
        return [aRoadName, aRoadType, aRoadSuffix].joined(separator: " ")
    }

    var bRoad: String {
        return [bRoadName, bRoadType, bRoadSuffix].joined(separator: " ")
    }

    var locationDescription: String {
        return "\(environmentName.localizedCapitalized), \(locality.localizedCapitalized)"
    }

    var localizedInstructions: String {
        //The directions text in the dataset is gross… wish I could do more than this
        let title = "EMERG MRKR \(markerId): "

        return directions
            .replacingOccurrences(of: "=>", with: "\t→")
            .replacingOccurrences(of: title, with: "")
            .replacingOccurrences(of: "NEAREST I/S", with: "NEAREST INTERSECTION:")
            .replacingOccurrences(of: "   ", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
    }

    var hasMarkerAddress: Bool { return markerAddress.trimmingCharacters(in: CharacterSet.whitespaces) != "" }

    var pointAnnotation: MKPointAnnotation {
        let annoation = MKPointAnnotation()
        annoation.coordinate = self.coordinate
        annoation.title = self.markerId
        return annoation
    }
}
