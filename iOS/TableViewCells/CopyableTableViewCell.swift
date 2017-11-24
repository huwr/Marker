//
//  CopyableTableViewCell.swift
//  Emergency Markers Tests
//
//  Created by Huw Rowlands on 25/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

class CopyableTableViewCell: UITableViewCell {

    override func layoutIfNeeded() {
        detailLabel?.isUserInteractionEnabled = false
    }

    var title: String = "" { didSet {
        titleLabel?.text = title
        } }

    var detail: String = "" { didSet {
        detailLabel?.text = detail
        } }

    @IBOutlet var detailLabel: UITextField?
    @IBOutlet var titleLabel: UILabel?
}
