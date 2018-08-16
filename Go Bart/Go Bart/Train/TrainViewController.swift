//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons
import PinLayout

class TrainViewController: UIViewController, StationSearchBarDelegate, DepartureListViewDelegate, TripListViewDelegate {
    var fromStationData: Station!
    var toStationData: Station!

    var stationSearchBar: StationSearchBar!
    var departureListView : DepartureListView!
    var tripListView: TripListView!

    var safeArea: UILayoutGuide!
    var currentDetailViewController: RouteDetailViewController!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Trains"
        self.tabBarItem = UITabBarItem(title: "Train", image: UIImage(icon: .fontAwesomeSolid(.subway), size: CGSize(width: 32, height: 32)), tag: 0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.safeArea = self.view.safeAreaLayoutGuide

        self.stationSearchBar = StationSearchBar()
        self.stationSearchBar.delegate = self

        self.departureListView = DepartureListView()
        self.departureListView.departureListDelegate = self
        self.departureListView.refreshControl = UIRefreshControl()
        self.departureListView.refreshControl?.addTarget(self, action: #selector(updateDepartureList), for: .valueChanged)

        self.tripListView = TripListView()
        self.tripListView.tripListDelegate = self
        self.tripListView.refreshControl = UIRefreshControl()
        self.tripListView.rowHeight = UITableViewAutomaticDimension
        self.tripListView.refreshControl?.addTarget(self, action: #selector(updateTripList), for: .valueChanged)

        self.view.addSubview(self.stationSearchBar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.stationSearchBar.pin.horizontally(view.pin.safeArea).top(view.pin.safeArea)
    }

    func placeDepartureList() {
        self.view.addSubview(self.departureListView)
        self.view.bringSubview(toFront: self.stationSearchBar)

        self.departureListView.pin.horizontally(view.pin.safeArea).bottom(view.pin.safeArea).below(of: self.stationSearchBar)
    }

    func placeTripList() {
        self.view.addSubview(self.tripListView)
        self.view.bringSubview(toFront: self.stationSearchBar)

        self.tripListView.pin.horizontally(view.pin.safeArea).bottom(view.pin.safeArea).below(of: self.stationSearchBar)
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
            BartRealTimeService.getSelectedDepartures(for: self.fromStationData) { departures in
                self.tripListView.trips = trips
                self.tripListView.departures = departures
                self.tripListView.station = self.fromStationData
                self.tripListView.destination = self.toStationData
                self.tripListView.reloadData()
                if (trips.count > 0 && self.tripListView.numberOfRows(inSection: 0) > 0) {
                    self.tripListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                self.tripListView.refreshControl?.endRefreshing()
            }
        }
    }

    private func openStationPicker(with title: String, afterSelected: @escaping (Station) -> Void) {
        self.hidesBottomBarWhenPushed = true
        let target = StationPickerViewController().with(barTitle: title).onStationSelected(selectedHandler: afterSelected)
        self.show(target, sender: self)
        self.hidesBottomBarWhenPushed = false
    }

    private func openRouteDetail(from station: Station, to destination: Station? = nil, departure: Departure? = nil, trip: Trip? = nil) {
        self.currentDetailViewController = RouteDetailViewController(from: station, to: destination, at: departure, on: trip)
        self.present(RouteDetailNavigationViewController(
                rootViewController: self.currentDetailViewController
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
        self.openRouteDetail(from: self.fromStationData, departure: departure)
    }

    func onTripSelected(trip: Trip, from station: Station, to destination: Station, with departure: Departure?) {
        self.openRouteDetail(from: self.fromStationData, to: self.toStationData, departure: departure, trip: trip)
    }

}
