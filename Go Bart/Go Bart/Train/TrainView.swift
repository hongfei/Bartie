//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class TrainView {
    let view: UIView!
    let safeArea: UILayoutGuide!

    var fromStation: FromStationSearchBar = FromStationSearchBar()
    var toStation: ToStationSearchBar = ToStationSearchBar()

    var departureListView: DepartureListView = DepartureListView()
    var tripListView: TripListView = TripListView()

    init(view: UIView) {
        self.view = view
        self.safeArea = self.view.safeAreaLayoutGuide
        self.view.backgroundColor = UIColor.white

        self.departureListView.refreshControl = UIRefreshControl()
        self.tripListView.refreshControl = UIRefreshControl()

        placeFromStation()
        placeDepartureList()
        self.view.sizeToFit()
    }

    public func placeFromStation() {
        self.view.addSubview(fromStation)

        NSLayoutConstraint.activate([
            fromStation.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            fromStation.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            fromStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            fromStation.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    public func placeToStation() {
        self.view.addSubview(toStation)
        self.fromStation.searchBox.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.toStation.searchBox.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        NSLayoutConstraint.activate([
            toStation.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            toStation.topAnchor.constraint(equalTo: fromStation.bottomAnchor),
            toStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            toStation.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    public func placeDepartureList() {
        self.view.addSubview(self.departureListView)

        if self.toStation.isDescendant(of: self.view) {
            self.departureListView.topAnchor.constraint(equalTo: self.fromStation.bottomAnchor).isActive = false
            self.departureListView.topAnchor.constraint(equalTo: self.toStation.bottomAnchor).isActive = true
        } else {
            self.departureListView.topAnchor.constraint(equalTo: self.toStation.bottomAnchor).isActive = false
            self.departureListView.topAnchor.constraint(equalTo: self.fromStation.bottomAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            departureListView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            departureListView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            departureListView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor)
        ])
    }

    public func placeTripList() {
        self.view.addSubview(self.tripListView)

        NSLayoutConstraint.activate([
            tripListView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            tripListView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            tripListView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            tripListView.topAnchor.constraint(equalTo: self.toStation.bottomAnchor)
        ])
    }

    func updateFromStation(from station: Station) {
        self.departureListView.removeFromSuperview()
        self.tripListView.removeFromSuperview()
        if !self.toStation.isDescendant(of: self.view) {
            placeToStation()
        }
        self.fromStation.reloadStation(station: station)
        self.toStation.reloadStation(station: nil)
        placeDepartureList()
    }

    func updateToStation(to station: Station) {
        self.departureListView.removeFromSuperview()
        self.tripListView.removeFromSuperview()
        self.toStation.reloadStation(station: station)
        placeTripList()
    }

    func addFromGesture(gestureRecognizer: UIGestureRecognizer) {
        self.fromStation.addGestureRecognizer(gestureRecognizer)
    }

    func addToGesture(gestureRecognizer: UIGestureRecognizer) {
        self.toStation.addGestureRecognizer(gestureRecognizer)
    }

    func updateDepartureList(departures: [Departure], onItemSelected: @escaping (Departure) -> Void) -> Void {
        departureListView.setDataSource(dataSource: DepartureListDataSource(departures: departures))
        departureListView.setDelegate(delegate: DepartureListDelegate(onSelected: onItemSelected))
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
