//
//  MockMarker.swift
//  Emergency Markers Tests
//
//  Created by Huw Rowlands on 17/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MockMarker: NSObject, MarkerProtocol {
    var coordinate = CLLocationCoordinate2D(latitude: .init(-37.8136), longitude: .init(144.9631))

    var directions: String = "GO DOWN THE PATH"

    var markerId: String = "TEST-123"

    var locality: String = "Test Land"

    var environmentName: String = "Test City"

    var aRoad: String = "Big Road"

    var bRoad: String = "Smaller Road"

    var markerAddress: String = "123 Test Street"

    convenience init(markerId: String) {
        self.init()
        self.markerId = markerId
    }
}
