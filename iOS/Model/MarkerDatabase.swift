//
//  MarkerDatabase.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 15/8/18.
//  Copyright © 2018 Huw Rowlands. All rights reserved.
//

import Foundation
import CoreLocation

protocol MarkerDatabase {
    var count: Int { get }
    func all() -> [Marker]
    func with(markerId: String) -> [Marker]
    func with(keyword: String) -> [Marker]
    func closestTo(location: CLLocation) -> Marker?
}
