//
//  Marker.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Marker: Object, MarkerProtocol {

    @objc dynamic var xPosition: Double = 0
    @objc dynamic var yPosition: Double = 0
    @objc dynamic var markerId = ""
    @objc dynamic var markerAddress = ""
    @objc dynamic var markerStatus = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var environmentName = ""
    @objc dynamic var aRoadName = ""
    @objc dynamic var aRoadType = ""
    @objc dynamic var aRoadSuffix = ""
    @objc dynamic var bRoadName = ""
    @objc dynamic var bRoadType = ""
    @objc dynamic var bRoadSuffix = ""
    @objc dynamic var locality = ""
    @objc dynamic var dirText = ""
    @objc dynamic var objectId = 0

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    override var description: String {
        return dirText
    }
}
