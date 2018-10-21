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
    var station: Station?
    var destination: Station?

    var stationSearchBar: StationSearchBar!
    var departureListView: DepartureListView!
    var tripListView: TripListView!
    var locationManager: CLLocationManager!
    var getLocationNavBarItem: UIBarButtonItem!
    var locatingNavBarItem: UIBarButtonItem!
    var locatingIndicator: UIActivityIndicatorView!
    var updateTimer: Timer!

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
        
        self.setFromStationByLocation()
        self.updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(reloadList), userInfo: nil, repeats: true)
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
        guard let stnt = self.station else { return }
        RealTimeService.getSelectedDepartures(for: stnt) { departures in
            self.departureListView.departures = departures
            self.departureListView.reloadData()

            if (departures.count > 0 && self.departureListView.numberOfRows(inSection: 0) > 0) {
                self.departureListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.departureListView.refreshControl?.endRefreshing()
        }
    }

    @IBAction func updateTripList() {
        guard let stnt = self.station, let dst = self.destination else {
            return
        }
        ScheduleService.getTripPlan(from: stnt, to: dst, beforeCount: 1, afterCount: 4) { trips in
            RealTimeService.getSelectedDepartures(for: stnt) { departures in
                self.tripListView.reloadTripList(trips: trips, with: departures, from: stnt, to: dst)
                if (trips.count > 0 && self.tripListView.numberOfRows(inSection: 0) > 0) {
                    self.tripListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                self.tripListView.refreshControl?.endRefreshing()
            }
        }
    }

    private func openStationPicker(with title: String, afterSelected: @escaping (Station) -> Void) {
        self.hidesBottomBarWhenPushed = true
        let target = StationPickerViewController().onStationSelected(selectedHandler: afterSelected)
        target.title = title
        self.show(target, sender: self)
        self.hidesBottomBarWhenPushed = false
    }

    private func openRouteDetail(from station: Station, to destination: Station? = nil, departure: Departure? = nil, trip: Trip? = nil) {
        let currentDetailViewController = RouteDetailViewController(from: station, to: destination, at: departure, on: trip)
        self.present(RouteDetailNavigationViewController(rootViewController: currentDetailViewController), animated: true)
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
        self.openRouteDetail(from: self.station!, departure: departure)
    }

    func onTripSelected(trip: Trip, from station: Station, to destination: Station, with departure: Departure?) {
        self.openRouteDetail(from: self.station!, to: self.destination, departure: departure, trip: trip)
    }

    func onDeleteTopBoxContent() {
        self.destination = nil
        self.reloadList()
    }

    @IBAction func reloadList() {
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
            self.locationManager.desiredAccuracy = 20
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
            StationService.getClosestStation(from: currentLocation) { station in
                self.station = station
                self.reloadList()
                self.locatingIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem = self.getLocationNavBarItem
            }
            manager.stopUpdatingLocation()
        }
    }
}
