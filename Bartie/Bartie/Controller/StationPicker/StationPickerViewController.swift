//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift


class StationPickerViewController: UITableViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: nil)

    var stations: [Station] = []
    var filteredStations: [Station] = []
    var selectedHandler: ((Station) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tableView.register(StationTableCell.self, forCellReuseIdentifier: "StationTableCell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        setSearchController()

        StationService.getAllStations() { stations in
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
        self.searchController.searchBar.barTintColor = .white
        if let textfield = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        }
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let stationCell = tableView.dequeueReusableCell(withIdentifier: "StationTableCell") as? StationTableCell  {
            stationCell.station = self.filteredStations[indexPath.row]
            stationCell.reloadStation()
            return stationCell
        }

        return StationTableCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStations.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStation = self.filteredStations[indexPath.row]
        self.navigationController?.popViewController(animated: true)
        if let handler = self.selectedHandler {
            handler(selectedStation)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StationTableCell.HEIGHT
    }

    func onStationSelected(selectedHandler: @escaping (Station) -> Void) -> StationPickerViewController {
        self.selectedHandler = selectedHandler
        return self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredStations = self.stations.filter { station in station.name.contains(searchText) }
        } else {
            filteredStations = self.stations
        }
        tableView.reloadData()
    }
}
