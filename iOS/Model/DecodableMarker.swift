//
//  DecodableMarker.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 19/8/18.
//  Copyright © 2018 Huw Rowlands. All rights reserved.
//

import Foundation

struct DecodableMarker: Marker, Decodable {
    var markerId: String

    var latitude: Double
    var longitude: Double

    var environmentName: String

    var aRoadName: String
    var aRoadType: String
    var aRoadSuffix: String

    var bRoadName: String
    var bRoadType: String
    var bRoadSuffix: String

    var locality: String

    var directions: String
    var markerAddress: String

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case directions = "dirText"
        case markerId
        case locality
        case environmentName
        case aRoadName
        case aRoadType
        case aRoadSuffix
        case bRoadName
        case bRoadType
        case bRoadSuffix
        case markerAddress
    }
}
