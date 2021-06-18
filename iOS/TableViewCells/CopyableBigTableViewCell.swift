//
//  CopyableBigTableViewCell.swift
//  Emergency Markers Tests

import UIKit

class CopyableBigTableViewCell: UITableViewCell {

    var title: String = "" { didSet {
        titleLabel?.text = title
        } }

    @IBOutlet var titleLabel: UILabel?

    override var accessibilityLabel: String? {
        get {
            return "\(title)"
        }
        set {
            super.accessibilityLabel = newValue
        }
    }
}
