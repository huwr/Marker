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

struct MockMarkerFactory {
    static var marker: Marker? {
        return MarkerFileDatabase.init(with: mockText.data(using: .utf8))?.all().first
    }
}

let mockText = """
[
{
"xPosition": 145.18014500200437,
"yPosition": -37.75653799691778,
"markerId": "MAN125",
"markerAddress": "",
"markerStatus": "IN CAD",
"latitude": -37.75654,
"longitude": 145.1801,
"environmentName": "MANNINGHAM CITY",
"aRoadName": "HARMAN",
"aRoadType": "CL",
"aRoadSuffix": "",
"bRoadName": "DEEP CREEK",
"bRoadType": "DR",
"bRoadSuffix": "",
"locality": "DONCASTER EAST",
"dirText": "EMERG MRKR MAN125: NEAREST I/S HARMAN CL & DEEP CREEK DR\\n=> TRAVEL NORTH-EAST 65M ALONG DEEP CRK DRV ARRIVE BIKE ACCESS TRL",
"objectId": 2001
}
]
"""
