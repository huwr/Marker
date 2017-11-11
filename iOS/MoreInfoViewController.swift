//
//  MoreInfoViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 11/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

class MoreInfoViewController: UITableViewController {
    var marker: MarkerProtocol?

    @IBAction func dismiss() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        self.title = marker?.markerId ?? "No Marker"
    }
}
