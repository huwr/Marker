//
//  String+padLefy.swift
//  UTMFramework
//
//  Created by Huw Rowlands on 29/9/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import Foundation

extension String {
    func padLeft (totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
}
