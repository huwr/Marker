//
//  MarkerDB.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

private func migrateRealmSeeds() {
    let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
    let bundleRealmPath = Bundle.main.url(forResource: "markers", withExtension: "realm")

    if !FileManager.default.fileExists(atPath: defaultRealmPath.absoluteString) {
        do {
            try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
        } catch let error {
            print("error copying seeds: \(error)")
        }
    }
}

struct MarkerDB {
    init() {
        migrateRealmSeeds()

        do {
            realm = try Realm()
        } catch let error {
            print("Could not open realm db! Error:\n\(error)")
            fatalError("\(error)")
        }

        markers = realm.objects(Marker.self).sorted(byKeyPath: "markerId")
        print("loaded markers \(markers.count)")
    }

    // MARK: Realm
    private let realm: Realm

    private var markers: Results<Marker>

    // MARK: Public

    var count: Int {
        return markers.count
    }

    func all() -> [MarkerProtocol] {
        return Array(markers)
    }

    func with(markerId: String) -> [MarkerProtocol] {
        return Array(markers.filter("markerId CONTAINS '\(markerId)'"))
    }

    func with(keyword: String) -> [MarkerProtocol] {
        return Array(markers.filter("markerId CONTAINS '\(keyword)' OR environmentName CONTAINS '\(keyword)' OR locality CONTAINS '\(keyword)'"))
    }

    func closestTo(location: CLLocation) -> MarkerProtocol? {
        return all().min { first, second in first.distance(from: location) ?? 0 < second.distance(from: location) ?? 0 }
    }
}
