//
//  FileMarkerDatabase.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 15/8/18.
//  Copyright © 2018 Huw Rowlands. All rights reserved.
//

import Foundation
import CoreLocation

private func loadFromFile() -> Data? {
    guard let path = Bundle.main.path(forResource: "Marker", ofType: "json"),
        let string = try? String(contentsOfFile: path),
        let data = string.data(using: .utf8) else {
        return nil
    }

    return data
}

struct MarkerFileDatabase: MarkerDatabase {
    private var markers: [Marker] = []

    init?(with data: Data? = loadFromFile()) {
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()

        do {
            markers = try decoder.decode([DecodableMarker].self, from: data).sorted(by: { lhs, rhs in
                lhs.markerId < rhs.markerId
            })
        } catch let error {
            print("Could not do it because \(error)")
        }
    }

    var count: Int {
        return markers.count
    }

    func all() -> [Marker] {
        return markers
    }

    func with(keyword: String) -> [Marker] {
        return markers.filter { marker in
            searchableKeyPaths.contains { keyPath in
                marker[keyPath: keyPath].contains(keyword)
            }
        }
    }

    private var searchableKeyPaths: [KeyPath<Marker, String>] {
        return [
            \Marker.markerId,
            \Marker.locality,
            \Marker.environmentName,
            \Marker.aRoad,
            \Marker.bRoad,
            \Marker.markerAddress
        ]
    }
}
