//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons
import PinLayout
import CoreLocation

class TrainViewController: UIViewController, StationSearchBarDelegate, DepartureListViewDelegate, TripListViewDelegate, CLLocationManagerDelegate {
    var station: Station!
    var destination: Station?

    var stationSearchBar: StationSearchBar!
    var departureListView: DepartureListView!
    var tripListView: TripListView!
    var locationManager: CLLocationManager!
    var getLocationNavBarItem: UIBarButtonItem!
    var locatingNavBarItem: UIBarButtonItem!
    var locatingIndicator: UIActivityIndicatorView!

    var safeArea: UILayoutGuide!
    var currentDetailViewController: RouteDetailViewController!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Trains"
        self.tabBarItem = UITabBarItem(title: "Trains", image: Icons.train, tag: 0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white

        self.getLocationNavBarItem = UIBarButtonItem(image: Icons.locating, style: .plain, target: self, action:  #selector(setFromStationByLocation))
        self.getLocationNavBarItem.tintColor = .white
        self.locatingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.locatingNavBarItem = UIBarButtonItem(customView: self.locatingIndicator)

        self.navigationItem.rightBarButtonItem = self.getLocationNavBarItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.safeArea = self.view.safeAreaLayoutGuide

        self.locationManager = CLLocationManager()

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

    @IBAction func updateDepartureList() {
        BartRealTimeService.getSelectedDepartures(for: self.station) { departures in
            self.departureListView.departures = departures
            self.departureListView.reloadData()

            if (departures.count > 0 && self.departureListView.numberOfRows(inSection: 0) > 0) {
                self.departureListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.departureListView.refreshControl?.endRefreshing()
        }
    }

    @IBAction func updateTripList() {
        guard let dst = self.destination else {
            return
        }
        BartScheduleService.getTripPlan(from: self.station, to: dst) { trips in
            BartRealTimeService.getSelectedDepartures(for: self.station) { departures in
                self.tripListView.reloadTripList(trips: trips, with: departures, from: self.station, to: dst)
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
            self.station = station
            self.reloadList()
        }
    }

    func onTapToBox(textField: UITextField) {
        self.openStationPicker(with: "Pick Destination") { station in
            self.destination = station
            self.reloadList()
        }
    }

    func removeCurrentList() {
        self.departureListView.removeFromSuperview()
        self.tripListView.removeFromSuperview()
    }

    func onDepartureSelected(departure: Departure) {
        self.openRouteDetail(from: self.station, departure: departure)
    }

    func onTripSelected(trip: Trip, from station: Station, to destination: Station, with departure: Departure?) {
        self.openRouteDetail(from: self.station, to: self.destination, departure: departure, trip: trip)
    }

    func onDeleteTopBoxContent() {
        self.destination = nil
        self.reloadList()
    }

    func reloadList() {
        self.removeCurrentList()
        self.stationSearchBar.reloadStation(from: self.station, to: self.destination)

        if let _ = self.destination {
            self.placeTripList()
            self.updateTripList()
        } else {
            self.placeDepartureList()
            self.updateDepartureList()
        }
    }

    @IBAction func setFromStationByLocation() {
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = 30
            self.locationManager.startUpdatingLocation()
            self.navigationItem.rightBarButtonItem = self.locatingNavBarItem
            self.locatingIndicator.startAnimating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locatingIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem = self.getLocationNavBarItem
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = manager.location {
            BartStationService.getAllStations() { stations in
                self.station = DataUtil.getClosestStation(in: stations, to: currentLocation)
                self.reloadList()
                self.locatingIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem = self.getLocationNavBarItem
            }
            manager.stopUpdatingLocation()
        }
    }
}
