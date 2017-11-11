//
//  DirectionsViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 11/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {
    var marker: MarkerProtocol? { didSet {
        configureView()
    }}

    @IBOutlet weak var directionsView: UITextView?

    func configureView() {
        if let marker = marker {
            directionsView?.text = marker.localizedDirections
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
}