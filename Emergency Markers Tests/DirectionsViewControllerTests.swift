//
//  Emergency_Markers_Tests.swift
//  Emergency Markers Tests
//
//  Created by Huw Rowlands on 17/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Quick
import Nimble

class DirectionsViewControllerTests: QuickSpec {
    override func spec() {
        var subject: DirectionsViewController?
        var marker: MarkerProtocol?

        describe("setting the marker") {
            beforeEach {
                subject = DirectionsViewController()
                subject?.directionsView = UITextView()
                marker = MockMarker()
            }

            it("sets the localised directions when setting marker") {
                subject?.marker = marker
                expect(subject?.directionsView?.text).to(equal(marker?.localizedDirections))
            }
        }
    }
}
