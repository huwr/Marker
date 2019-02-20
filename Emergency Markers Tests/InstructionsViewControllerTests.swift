//
//  Emergency_Markers_Tests.swift
//  Emergency Markers Tests
//
//  Created by Huw Rowlands on 17/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Quick
import Nimble
@testable import Emergency_Markers

class InstructionsViewControllerTests: QuickSpec {
    override func spec() {
        var subject: InstructionsViewController?
        let marker: Marker = MockMarker.defaultInstance()

        describe("setting the marker") {
            beforeEach {
                subject = InstructionsViewController()
                subject?.directionsView = UITextView()
            }

            it("sets the localised directions when setting marker") {
                subject?.marker = marker
                expect(subject?.directionsView?.text).to(equal(marker.localizedInstructions))
            }
        }
    }
}
