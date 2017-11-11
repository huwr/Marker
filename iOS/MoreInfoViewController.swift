//
//  MoreInfoViewController.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 11/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

fileprivate typealias MarkerAttribute = (name: String, value: CustomStringConvertible)

class MoreInfoViewController: UITableViewController {
    var marker: MarkerProtocol? { didSet {
        if let marker = marker {
            markerAttributes = attributes(marker)
        } else { markerAttributes = nil }
    }}

    fileprivate var markerAttributes: [MarkerAttribute]?

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
                attributes: self.markerAttributes,
                index: indexPath.row)
        default:
            return tableView.dequeueReusableCell(withIdentifier: "directionsCell", for: indexPath)
        }
    }

    private func cellForAttribute(cell: UITableViewCell, attributes: [MarkerAttribute]?, index: Int) -> UITableViewCell {
        guard let attributes = attributes else { return cell }
        cell.textLabel?.text = attributes[index].name
        cell.detailTextLabel?.text = attributes[index].value.description
        return cell
    }

    // MARK: Segueing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDirections", let destinationVC = segue.destination as? DirectionsViewController {
            destinationVC.marker = marker
        }
    }

    // MARK: Marker manipulating…

    //This should probably be elsewhere but meh
    private func attributes(_ marker: MarkerProtocol) -> [MarkerAttribute] {
        var attributes: [MarkerAttribute] = [
            ("ID", marker.markerId),
            ("Locality", marker.locality.localizedCapitalized),
            ("Environment", marker.environmentName.localizedCapitalized),
            ("Latitude", "\(marker.coordinate.latitude)"),
            ("Longitude", "\(marker.coordinate.longitude)"),
            ("A Road", "\(marker.aRoad.localizedCapitalized)"),
            ("B Road", "\(marker.bRoad.localizedCapitalized)")
        ]

        if marker.hasMarkerAddress {
            attributes.append(("Address", "\(marker.markerAddress.localizedCapitalized)"))
        }

        return attributes
    }
}