//
//  DirectionsViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 11/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    var marker: Marker? { didSet {
        configureView()
    }}

    @IBOutlet var directionsView: UITextView?

    func configureView() {
        directionsView?.text = marker?.localizedInstructions
    }

    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
}
