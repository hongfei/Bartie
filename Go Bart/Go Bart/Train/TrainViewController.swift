//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons

class TrainViewController: UIViewController, StationSearchBarDelegate, DepartureListViewDelegate, TripListViewDelegate {
    var fromStationData: Station!
    var toStationData: Station!

    var stationSearchBar = StationSearchBar()
    var departureListView = DepartureListView()
    var tripListView = TripListView()

    var safeArea: UILayoutGuide!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Trains"
        self.tabBarItem = UITabBarItem(title: "Train", image: UIImage(icon: .fontAwesomeSolid(.subway), size: CGSize(width: 32, height: 32)), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.safeArea = self.view.safeAreaLayoutGuide

        setNavigationBar()
        placeStationSearchBar()
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor("#3359D1")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }

    func placeStationSearchBar() {
        self.stationSearchBar.delegate = self
        self.view.addSubview(self.stationSearchBar)

        NSLayoutConstraint.activate([
            stationSearchBar.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            stationSearchBar.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            stationSearchBar.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor)
        ])
    }

    func placeDepartureList() {
        self.departureListView.departureListDelegate = self
        self.departureListView.refreshControl = UIRefreshControl()
        self.departureListView.refreshControl?.addTarget(self, action: #selector(updateDepartureList), for: .valueChanged)
        self.view.addSubview(self.departureListView)

        NSLayoutConstraint.activate([
            departureListView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            departureListView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            departureListView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            departureListView.topAnchor.constraint(equalTo: self.stationSearchBar.bottomAnchor)

        ])
    }

    func placeTripList() {
        self.tripListView.tripListDelegate = self
        self.tripListView.refreshControl = UIRefreshControl()
        self.tripListView.refreshControl?.addTarget(self, action: #selector(updateTripList), for: .valueChanged)
        self.view.addSubview(self.tripListView)

        NSLayoutConstraint.activate([
            tripListView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            tripListView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            tripListView.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            tripListView.topAnchor.constraint(equalTo: self.stationSearchBar.bottomAnchor)
        ])
    }

    @objc func updateDepartureList() {
        BartRealTimeService.getSelectedDepartures(for: self.fromStationData) { departures in
            self.departureListView.departures = departures
            self.departureListView.reloadData()

            if (departures.count > 0 && self.departureListView.numberOfRows(inSection: 0) > 0) {
                self.departureListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.departureListView.refreshControl?.endRefreshing()
        }
    }

    @objc func updateTripList() {
        BartScheduleService.getTripPlan(from: self.fromStationData, to: self.toStationData) { trips in
            self.tripListView.trips = trips
            self.tripListView.reloadData()

            if (trips.count > 0 && self.tripListView.numberOfRows(inSection: 0) > 0) {
                self.tripListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.tripListView.refreshControl?.endRefreshing()
        }
    }

    private func openStationPicker(with title: String, afterSelected: @escaping (Station) -> Void) {
        self.hidesBottomBarWhenPushed = true
        let target = StationPickerViewController().with(barTitle: title).onStationSelected(selectedHandler: afterSelected)
        self.show(target, sender: self)
        self.hidesBottomBarWhenPushed = false
    }

    private func openRouteDetail(from station: Station, to destination: Station? = nil, departure: Departure? = nil, trip: Trip? = nil) {
        self.present(RouteDetailNavigationViewController(
                rootViewController:RouteDetailViewController().with(from: station, to: destination, departure: departure, trip: trip)
        ), animated: true)
    }

    func onTapFromBox(textField: UITextField) {
        self.openStationPicker(with: "Pick Station") { station in
            self.fromStationData = station
            self.removeCurrentList()
            self.stationSearchBar.reloadStation(from: station, to: nil)
            self.placeDepartureList()
            self.updateDepartureList()
        }
    }

    func onTapToBox(textField: UITextField) {
        self.openStationPicker(with: "Pick Destination") { station in
            self.toStationData = station
            self.removeCurrentList()
            self.stationSearchBar.reloadStation(from: self.fromStationData, to: self.toStationData)
            self.placeTripList()
            self.updateTripList()
        }
    }

    func removeCurrentList() {
        self.departureListView.removeFromSuperview()
        self.tripListView.removeFromSuperview()
    }

    func onDepartureSelected(departure: Departure) {

    }

    func onTripSelected(trip: Trip) {

    }

}
