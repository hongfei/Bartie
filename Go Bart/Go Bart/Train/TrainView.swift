//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class TrainView {
    let view: UIView!
    let safeArea: UILayoutGuide!

    var stationSearchBar: StationSearchBar = StationSearchBar()
    var departureListView: DepartureListView = DepartureListView()
    var tripListView: TripListView = TripListView()

    var fromStation: Station!
    var toStation: Station!

    init(view: UIView) {
        self.view = view
        self.safeArea = self.view.safeAreaLayoutGuide
        self.view.backgroundColor = UIColor.white

        self.departureListView.refreshControl = UIRefreshControl()
        self.tripListView.refreshControl = UIRefreshControl()

        placeStationSearchBar()
        placeDepartureList()
        self.view.sizeToFit()
    }

    public func placeStationSearchBar() {
        self.view.addSubview(self.stationSearchBar)

        NSLayoutConstraint.activate([
            stationSearchBar.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            stationSearchBar.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            stationSearchBar.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor)
        ])
    }

    public func placeDepartureList() {
        self.view.addSubview(self.departureListView)

        NSLayoutConstraint.activate([
            departureListView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            departureListView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            departureListView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            departureListView.topAnchor.constraint(equalTo: self.stationSearchBar.bottomAnchor)

        ])
    }

    public func placeTripList() {
        self.view.addSubview(self.tripListView)

        NSLayoutConstraint.activate([
            tripListView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            tripListView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            tripListView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            tripListView.topAnchor.constraint(equalTo: self.stationSearchBar.bottomAnchor)
        ])
    }

    func updateFromStation(from station: Station) {
        self.departureListView.removeFromSuperview()
        self.tripListView.removeFromSuperview()
        self.fromStation = station
        self.stationSearchBar.reloadStation(from: station, to: nil)
        placeDepartureList()
    }

    func updateToStation(to station: Station) {
        self.departureListView.removeFromSuperview()
        self.tripListView.removeFromSuperview()
        self.toStation = station
        self.stationSearchBar.reloadStation(from: self.fromStation, to: self.toStation)
        placeTripList()
    }

    func updateDepartureList(departures: [Departure], onItemSelected: @escaping (Departure) -> Void) -> Void {
        departureListView.departures = departures
        departureListView.reloadData()

        if (departures.count > 0) {
            departureListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        departureListView.refreshControl?.endRefreshing()
    }

    func updateTripList(trips: [Trip], onItemSelected: @escaping (Trip) -> Void) -> Void {
        tripListView.setDataSource(dataSource: TripListDataSource(trips: trips))
        tripListView.setDelegate(delegate: TripListDelegate(onSelected: onItemSelected))
        tripListView.reloadData()

        if (trips.count > 0) {
            tripListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        tripListView.refreshControl?.endRefreshing()
    }
}
