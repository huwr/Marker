//
//  MoreInfoViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 11/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit
import CoreLocation

let SEGUESHOWDIRECTIONS = "showDirections"

private let numberFormatter = NumberFormatter()

class MoreInfoViewController: UITableViewController {
    var sharer: MarkerSharer?

    var marker: MarkerProtocol? { didSet {
        sharer = MarkerSharer(viewController: self)
        sharer?.marker = marker
    }}

    var currentLocation: CLLocation?

    private lazy var markerAttributes: [MarkerAttribute]? = {
        guard let marker = marker else { return nil }

        var attributes = marker.attributes

        if let location = currentLocation, let distance = marker.distance(from: location) {
            attributes.append(("Distance", "\(self.formatDistance(distance)) metres"))
        }

        return attributes
    }()

    private func formatDistance(_ metres: Double) -> String {
        let number = NSNumber(value: metres.roundTo(0))

        numberFormatter.groupingSeparator = "\u{2008}"
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: number) ?? ""
    }

    @IBAction func dismiss() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = marker?.markerId ?? "No Marker"
    }

    // MARK: Table View

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // attributes and directions
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? markerAttributes?.count ?? 0 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return cellForAttribute(
                cell: tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath),
                attributes: self.markerAttributes?[indexPath.row],
                index: indexPath.row)
        default:
            return tableView.dequeueReusableCell(withIdentifier: "instructionsCell", for: indexPath)
        }
    }

    private func cellForAttribute(cell: UITableViewCell, attributes: MarkerAttribute?, index: Int) -> UITableViewCell {
        guard let attributes = attributes, let copyableCell = cell as? CopyableTableViewCell else { return cell }
        copyableCell.title = attributes.name
        copyableCell.detail = attributes.value.description
        return cell
    }

    // MARK: Copying!

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector,
                            forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return indexPath.section == 0 && action == #selector(copy(_:))
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector,
                            forRowAt indexPath: IndexPath, withSender sender: Any?) {

        guard action == #selector(copy(_:)),
            indexPath.section == 0 else {
                return
        }

        if let value = self.markerAttributes?[indexPath.row].value {
            UIPasteboard.general.string = "\(value)"
        }
    }

    // MARK: Segueing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUESHOWDIRECTIONS, let instructionsVC = segue.destination as? InstructionsViewController {
            instructionsVC.marker = marker
        }
    }

    // MARK: Sharing

    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        sharer?.presentShareDialog()
    }

}
