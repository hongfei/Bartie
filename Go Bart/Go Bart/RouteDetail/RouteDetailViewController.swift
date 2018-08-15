//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import SwiftIcons

class RouteDetailNavigationViewController: UINavigationController {
    var initialTouchPoint = CGPoint.zero
    var initialFramePoint = CGPoint.zero

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: RouteDetailNavigationBar.self, toolbarClass: nil)
        self.pushViewController(rootViewController, animated: false)
        self.modalPresentationStyle = .overFullScreen
        self.navigationBar.isTranslucent = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

class RouteDetailViewController: UIViewController, UITableViewDataSource {
    var fromStation: Station!
    var toStation: Station?
    var departure: Departure?
    var trip: Trip?

    var legends: [Legend] = []
    var tableView: RouteDetailContentList!
    var mapView: RouteDetailMapView!

    override var navigationItem: UINavigationItem {
        var navItem: UINavigationItem
        if let dep = self.departure {
            navItem = UINavigationItem(title: dep.destination!)
        } else {
            navItem = UINavigationItem(title: self.toStation!.name)
        }
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeRouteDetail))
        return navItem
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(from station: Station, to destination: Station? = nil, at departure: Departure? = nil, on trip: Trip? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.fromStation = station
        self.toStation = destination
        self.departure = departure
        self.trip = trip
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.safeAreaLayoutGuide

        retrieveMissingData() { (station, destination, departure, trip) in
            self.legends = trip.leg
            self.tableView = RouteDetailContentList()
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.view.addSubview(self.tableView)
            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
            self.tableView.dataSource = self
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return self.legends.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteDetailMapView") as! RouteDetailMapView
            self.mapView = cell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTripView") as! SingleTripView
            let leg = self.legends[indexPath.row]
            BartRouteService.getAllRoutes() { routes in
                if let route = routes.first(where: { route in route.routeID == leg.line }) {
                    BartRouteService.getDetailRouteInfo(for: route) { routeDetail in
                        DataUtil.extractStations(for: routeDetail, from: leg.origin, to: leg.destination) { stations in
                            self.mapView.showStations(stations: stations)
                            cell.reloadData(with: stations, legend: leg, route: routeDetail)
                        }
                    }
                }
            }

            return cell
        default:
            return UITableViewCell()
        }
    }

    @IBAction func closeRouteDetail() {
        self.dismiss(animated: true)
    }

    private func retrieveMissingData(completionHandler: @escaping (Station, Station, Departure?, Trip) -> Void) {
        if let actualTrip = self.trip {
            self.retrieveDeparture(by: actualTrip, completionHandler: completionHandler)
        } else if let actualDeparture = self.departure {
            self.retrieveTrip(by: actualDeparture, completionHandler: completionHandler)
        }
    }

    private func retrieveTrip(by departure: Departure, completionHandler: @escaping (Station, Station, Departure, Trip) -> Void) {
        BartStationService.getAllStations() { stations in
            let destination = stations.first(where: { station in station.abbr == departure.abbreviation })!
            BartScheduleService.getTripPlan(from: self.fromStation, to: destination, count: 12) { trips in
                let trip = DataUtil.findClosestTrip(in: trips, for: departure)
                completionHandler(self.fromStation, destination, departure, trip!)
            }
        }
    }

    private func retrieveDeparture(by trip: Trip, completionHandler: @escaping (Station, Station, Departure?, Trip) -> Void) {
        BartRealTimeService.getSelectedDepartures(for: self.fromStation) { departures in
            BartRouteService.getAllRoutes() { routes in
                let dep = DataUtil.findClosestDeparture(in: departures, for: trip)
                completionHandler(self.fromStation, self.toStation!, dep, trip)
            }
        }
    }
}
