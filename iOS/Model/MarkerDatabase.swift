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
    func with(keyword: String) -> [Marker]
    func closestTo(location: CLLocation) -> Marker?
}

extension MarkerDatabase {
    func closestTo(location: CLLocation) -> Marker? {
        return all().min { first, second in first.distance(from: location) ?? 0 < second.distance(from: location) ?? 0 }
    }
}
