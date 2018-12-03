//
//  Double+Rounding.swift
//  VetCalc
//
//  Created by Huw Rowlands on 9/4/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(_ places: UInt) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// A display version of the receiver, as a `String`. Rounds to nearest integer by default.
    ///
    /// - parameter places: The number of places to round to. By default, 0 places.
    func display(roundedTo places: UInt = 0) -> String {
        return places == 0 ? "\(Int(self))" : "\(self.roundTo(places))"
    }
}
