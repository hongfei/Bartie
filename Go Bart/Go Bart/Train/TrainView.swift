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

    init(view: UIView) {
        self.view = view
        self.safeArea = self.view.safeAreaLayoutGuide
        self.view.backgroundColor = UIColor.white

        placeFromStation()
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
        if self.toStation.isDescendant(of: self.view) {
            return
        }

        self.view.addSubview(toStation)
        NSLayoutConstraint.activate([
            toStation.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            toStation.topAnchor.constraint(equalTo: fromStation.bottomAnchor),
            toStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            toStation.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func updateFromStation(from station: Station) {
        self.departureListView.removeFromSuperview()
        placeToStation()

        self.fromStation.searchBox.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.toStation.searchBox.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.fromStation.reloadStation(station: station)
    }

    func upToStation(to station: Station) {
        self.toStation.reloadStation(station: station)
    }

    func addFromGesture(gestureRecognizer: UIGestureRecognizer) {
        self.fromStation.addGestureRecognizer(gestureRecognizer)
    }

    func addToGesture(gestureRecognizer: UIGestureRecognizer) {
        self.toStation.addGestureRecognizer(gestureRecognizer)
    }

    func displayDepartureList(departures: [Departure], onItemSelected: @escaping (Departure) -> Void) -> Void {
        departureListView.setDataSource(dataSource: DepartureListDataSource(departures: departures))
        departureListView.setDelegate(delegate: DepartureListDelegate(onSelected: onItemSelected))
        self.view.addSubview(departureListView)

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

}
