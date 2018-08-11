//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift


class StationPickerViewController: UITableViewController, UISearchResultsUpdating {
    // elements
    var safeArea: UILayoutGuide!
    var barTitle: String!
    let searchController = UISearchController(searchResultsController: nil)

    // data
    var stations: [Station]?
    var filteredStations: [Station]?

    // inner controls
    var selectedHandler: ((Station) -> Void)?

    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        return super.targetViewController(forAction: action, sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = barTitle
        self.view.backgroundColor = UIColor.white
        self.tableView.register(StationTableCell.self, forCellReuseIdentifier: "StationCollectionCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        setSearchController()

        BartStationService.getAllStations() { stations in
            self.stations = stations
            self.filteredStations = stations
            self.tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.dismiss(animated: false)
    }

    func setSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCollectionCell", for: indexPath)

        if let stationCell = cell as? StationTableCell {
            stationCell.setStation(station: (self.filteredStations?[indexPath.row])!)
            return stationCell
        } else {
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.filteredStations {
        case .some(let stns):
            return stns.count
        case .none:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStation = (self.filteredStations?[indexPath.row])!
        if let handler = self.selectedHandler {
            handler(selectedStation)
        }
        self.navigationController?.popViewController(animated: true)
    }

    func with(barTitle: String?) -> StationPickerViewController {
        self.barTitle = barTitle
        return self
    }

    func onStationSelected(selectedHandler: @escaping (Station) -> Void) -> StationPickerViewController {
        self.selectedHandler = selectedHandler
        return self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredStations = self.stations?.filter { station in
                return station.name.contains(searchText)
            }
        } else {
            filteredStations = self.stations
        }
        tableView.reloadData()
    }
}
