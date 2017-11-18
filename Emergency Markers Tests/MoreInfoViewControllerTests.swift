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
                expect(desintationVC.marker?.isEqual(marker)).to(beTrue())
            }
        }

        describe("view lifecycle") {
            let mockMarkerId = "MOCK MARKER"
            beforeEach {
                subject = MoreInfoViewController()
                marker = MockMarker.init(markerId: mockMarkerId)
                subject?.marker = marker
            }

            it("takes the marker's title when appearing") {
                subject?.viewWillAppear(false)
                expect(subject?.title).to(equal(mockMarkerId))
            }
        }
    }
}
