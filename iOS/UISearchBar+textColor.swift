//
//  UISearchBar+textColor.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textColor: UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                return textField.textColor
            } else {
                return nil
            }
        }

        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                textField.textColor = newValue
            }
        }
    }
}
