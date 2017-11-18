//
//  MoreInfoViewControllerTests.swift
//  Emergency Markers Tests
//
//  Created by Huw Rowlands on 18/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Quick
import Nimble
import UIKit

class MoreInfoViewControllerTests: QuickSpec {
    override func spec() {
        var subject: MoreInfoViewController?
        var marker: MarkerProtocol?

        describe("Segueing") {
            beforeEach {
                subject = MoreInfoViewController()
                marker = MockMarker()
                subject?.marker = marker
            }

            it("passes the marker to the next vc") {
                let desintationVC = DirectionsViewController()
                let segue = UIStoryboardSegue(identifier: SEGUESHOWDIRECTIONS, source: subject!, destination: desintationVC)

                subject?.prepare(for: segue, sender: nil)

                expect(desintationVC.marker).toNot(beNil())
                expect(desintationVC.marker?.markerId).to(equal(marker?.markerId))
            }

        }
    }
}
