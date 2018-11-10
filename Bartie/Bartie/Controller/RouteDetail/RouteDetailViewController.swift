//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import SwiftIcons
import PinLayout

class RouteDetailNavigationViewController: UINavigationController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: RoundCornerNavigationBar.self, toolbarClass: nil)
        self.pushViewController(rootViewController, animated: false)
        self.modalPresentationStyle = .overFullScreen
        self.navigationBar.isTranslucent = false
    }
}

class RouteDetailViewController: UIViewController {
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

        self.tableView = RouteDetailContentList()
        self.tableView.parentControllerView = self.navigationController
        self.view.addSubview(self.tableView)

        if let actualTrip = self.trip {
            self.tableView.trip = self.trip
            self.retrieveDeparture(by: actualTrip) { departure in
                self.tableView.reloadRouteDetail(from: self.fromStation, to: self.toStation, with: departure, of: actualTrip)
            }
        } else if let actualDeparture = self.departure {
            self.tableView.departure = actualDeparture
            self.retrieveTrip(by: actualDeparture) { trip in
                self.tableView.reloadRouteDetail(from: self.fromStation, to: self.toStation, with: actualDeparture, of: trip)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.pin.all()
    }

    @IBAction func closeRouteDetail() {
        self.dismiss(animated: true)
    }

    private func retrieveTrip(by departure: Departure, completionHandler: @escaping (Trip) -> Void) {
        guard let destinationAbbr = departure.abbreviation else {
            return
        }

        StationService.getStation(by: destinationAbbr) { destination in
            ScheduleService.getTripPlan(from: self.fromStation, to: destination, beforeCount: 1, afterCount: 4) { optionalTrips in
                if let trips = optionalTrips, let trip = ScheduleService.findClosestTrip(in: trips, for: departure) {
                    completionHandler(trip)
                }
            }
        }
    }

    private func retrieveDeparture(by trip: Trip, completionHandler: @escaping (Departure?) -> Void) {
        RealTimeService.getSelectedDepartures(for: self.fromStation) { optionalDepartures in
            if let departures = optionalDepartures {
                BartRouteService.getAllRoutes() { routes in
                    let dep = RealTimeService.findClosestDeparture(in: departures, for: trip)
                    completionHandler(dep)
                }
            }
        }
    }
}
