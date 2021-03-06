//
//  MarkerAttributes.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 24/3/18.
//  Copyright © 2018 Huw Rowlands. All rights reserved.
//

import Foundation
import CoreLocation

typealias MarkerAttribute = (name: String, value: CustomStringConvertible)

extension Marker {
    var attributes: [MarkerAttribute] {
        var baseAttributes: [MarkerAttribute] = [
            ("ID", self.markerId),
            ("Locality", self.locality.localizedCapitalized),
            ("Environment", self.environmentName.localizedCapitalized),
            ("Latitude", "\(self.coordinate.latitude)"),
            ("Longitude", "\(self.coordinate.longitude)"),
            ("A Road", self.aRoad.localizedCapitalized),
            ("B Road", self.bRoad.localizedCapitalized)
        ]

        if self.hasMarkerAddress {
            baseAttributes.append(("Address", "\(self.markerAddress.localizedCapitalized)"))
        }

        return baseAttributes
    }

    var sharingDescription: String {
        var desc = """
        Emergency Marker \(markerId)
        =======================


        """

        self.attributes.forEach { attribute in
            desc += "\(attribute.name): \(attribute.value)\n"
        }

        desc += """

        Instructions
        ------------
        \(localizedInstructions)

        """

        return desc
    }
}
