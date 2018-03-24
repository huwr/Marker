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

class MarkerProtocolTests: QuickSpec {
    override func spec() {
        let mockMarker: MockMarker = MockMarker(markerId: "TEST123")
        let subject: MarkerProtocol = mockMarker

        describe("instructions") {
            beforeEach {
                mockMarker.directions = """
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
                mockMarker.environmentName = "ENVIRONMENT NAME"
                mockMarker.locality = "LOCALITY NAME"
            }

            it("combines them nicely") {
                expect(subject.locationDescription).to(equal("Environment Name, Locality Name"))
            }
        }

        describe("location") {
            let testLat = CLLocationDegrees.init(-37.8633)
            let testLong = CLLocationDegrees.init(144.9802)
            let testUTM = "223074"

            beforeEach {
                mockMarker.coordinate = CLLocationCoordinate2D(latitude: testLat, longitude: testLong)
            }

            it("gives it to you as a corelocation") {
                expect(subject.location.coordinate.latitude).to(equal(testLat))
                expect(subject.location.coordinate.longitude).to(equal(testLong))
            }

            it("gives it to you a UTM") {
                expect(subject.location.coordinate.utmCoordinate().shortformUTM).to(equal(testUTM))
            }
        }
    }
}
