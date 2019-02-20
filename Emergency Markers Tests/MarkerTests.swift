//
//  MarkerProtocolTests.swift
//  Emergency Markers Tests
//
//  Created by Huw Rowlands on 25/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
@testable import Emergency_Markers

class MarkerTests: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
        var subject: Marker = MockMarker.defaultInstance()

        describe("instructions") {
            beforeEach {
                subject.markerId = "TEST123"
                subject.directions = """
EMERG MRKR TEST123: NEAREST I/S CORN HILL RD & MT BULLER RD
=> TRAVEL SOUTH 425M UPHILL ON MT BULLER RD TO HELL CORNER
=> THEN NORTH-WEST 130M ON GRASS HOME TRAIL BEHIND TRAFFIC CONTROL HUT AT HELL CORNER
=> NO VEHICLE ACCESS IN WINTER
"""
            }

            it("localises them to be more readable") {
                expect(subject.localizedInstructions).to(equal("""
                NEAREST INTERSECTION: CORN HILL RD & MT BULLER RD
                \t→ TRAVEL SOUTH 425M UPHILL ON MT BULLER RD TO HELL CORNER
                \t→ THEN NORTH-WEST 130M ON GRASS HOME TRAIL BEHIND TRAFFIC CONTROL HUT AT HELL CORNER
                \t→ NO VEHICLE ACCESS IN WINTER
                """
                ))
            }
        }

        describe("location description") {
            beforeEach {
                subject.environmentName = "ENVIRONMENT NAME"
                subject.locality = "LOCALITY NAME"
            }

            it("combines them nicely") {
                expect(subject.locationDescription).to(equal("Environment Name, Locality Name"))
            }
        }

        describe("location") {
            let testLat = CLLocationDegrees.init(-37.8633)
            let testLong = CLLocationDegrees.init(144.9802)

            beforeEach {
                subject.latitude = testLat
                subject.longitude = testLong
            }

            it("gives it to you as a corelocation") {
                expect(subject.location.coordinate.latitude).to(equal(testLat))
                expect(subject.location.coordinate.longitude).to(equal(testLong))
            }
        }

        describe("A road") {
            beforeEach {
                subject.aRoadName = "A-ROAD-NAME"
                subject.aRoadType = "A-ROAD-TYPE"
                subject.aRoadSuffix = "A-ROAD-SUFFIX"
            }

            it("combines all attributes nicely") {
                expect(subject.aRoad).to(equal("A-ROAD-NAME A-ROAD-TYPE A-ROAD-SUFFIX"))
            }
        }

        describe("B road") {
            beforeEach {
                subject.bRoadName = "B-ROAD-NAME"
                subject.bRoadType = "B-ROAD-TYPE"
                subject.bRoadSuffix = "B-ROAD-SUFFIX"
            }

            it("combines all attributes nicely") {
                expect(subject.bRoad).to(equal("B-ROAD-NAME B-ROAD-TYPE B-ROAD-SUFFIX"))
            }
        }
    }
}
