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
    var description: String { get }

    var markerId: String { get }
    var locality: String { get }
    var environmentName: String { get }
}
