//
//  MarkerProtocol.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 9/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol MarkerProtocol: MKAnnotation {
    var coordinate: CLLocationCoordinate2D { get }

    // CAD Directions
    var directions: String { get }
    var localizedInstructions: String { get }

    // Marker ID like KCT040
    var markerId: String { get }

    //eg DONCASTER EAST
    var locality: String { get }

    //eg MANNINGHAM CITY
    var environmentName: String { get }

    var aRoad: String { get }
    var bRoad: String { get }

    //eg TURNTABLE CAR PARK
    var markerAddress: String { get }
    var hasMarkerAddress: Bool { get }
}

extension MarkerProtocol {
    var location: CLLocation {
        return CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }

    func distance(from origin: CLLocation?) -> Double? {
        guard let origin = origin else { return nil }
        return origin.distance(from: location)
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

    var sharingDescription: String {
        var desc = """
        Emergency Marker \(markerId)
        =======================

        ID: \(markerId)
        Locality: \(locality.localizedCapitalized)
        Environment: \(environmentName.localizedCapitalized)
        Latitude: \(coordinate.latitude)
        Longitude: \(coordinate.longitude)
        A Road: \(aRoad.localizedCapitalized)
        B Road: \(bRoad.localizedCapitalized)
        """
        if hasMarkerAddress {
            desc += """
            Address: \(markerAddress.localizedCapitalized)
            """
        }

        desc += """


        Instructions
        ------------
        \(localizedInstructions)
        """

        return desc
    }
}
