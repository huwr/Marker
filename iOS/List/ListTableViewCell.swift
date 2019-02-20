//
//  SearchTableViewCell.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 23/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet var currentLocationIcon: UIImageView!
    @IBOutlet var detailLabel: UILabel?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var distanceLabel: UILabel?

    var title: String = "" { didSet {
        titleLabel?.text = title
    } }

    var detail: String = "" { didSet {
        detailLabel?.text = detail
    } }

    var distance: Double? { didSet {
        if let distance = distance {
            let displayValue = (distance / 1000).display(roundedTo: 2)
            distanceLabel?.text = "\(displayValue) Km"
        } else {
            distanceLabel?.text = ""
        }
    } }

    var isClosest: Bool = false { didSet {
        currentLocationIcon.isHidden = !isClosest
    } }
}
