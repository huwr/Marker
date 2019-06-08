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
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!

    func configure(with marker: Marker, isClosest: Bool, distance: Double?) {
        titleLabel.text = marker.markerId
        detailLabel.text = marker.locationDescription

        if let distance = distance {
            let displayValue = (distance / 1000).display(roundedTo: 2)
            distanceLabel!.text = "\(displayValue) Km"
            distanceLabel!.accessibilityLabel = "\(displayValue) kilometres"
        } else {
            distanceLabel!.text = ""
        }

        currentLocationIcon.isHidden = !isClosest
    }
}
