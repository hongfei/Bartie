//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import Foundation

class RouteDetailNavigationViewController: UINavigationController {
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
    }
}

class RouteDetailViewController: UIViewController {
    var fromStation: Station!
    var toStation: Station?
    var departure: Departure?
    var trip: Trip?

    var stationList: UITextView!

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

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        self.stationList = UITextView()
        self.stationList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.stationList)
        NSLayoutConstraint.activate([
            self.stationList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stationList.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.stationList.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.stationList.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        retrieveMissingData() { (station, destination, departure, trip) in
            self.initializeView(from: station, to: destination, with: departure, of: trip)
        }
    }

    @objc func closeRouteDetail() {
        self.dismiss(animated: true)
    }

    func with(from station: Station, to destination: Station? = nil, departure: Departure? = nil, trip: Trip? = nil) -> RouteDetailViewController {
        self.fromStation = station
        self.toStation = destination
        self.departure = departure
        self.trip = trip

        return self
    }

    private func initializeView(from station: Station, to destination: Station, with departure: Departure, of trip: Trip) {
        BartRouteService.getAllRoutes() { routes in
            if let route = routes.first(where: { route in route.hexcolor == departure.hexcolor }) {
                BartRouteService.getDetailRouteInfo(for: route) { routeDetail in
                    DataUtil.extractStations(for: routeDetail, from: station, to: destination) { stations in


                    }
                }
            }
        }
    }

    private func retrieveMissingData(completionHandler: @escaping (Station,  Station, Departure, Trip) -> Void) {
        if let actualTrip = self.trip {
            self.retrieveDeparture(by: actualTrip, completionHandler: completionHandler)
        }

        if let actualDeparture = self.departure {
            self.retrieveTrip(by: actualDeparture, completionHandler: completionHandler)
        }
    }

    private func retrieveTrip(by departure: Departure, completionHandler: @escaping (Station,  Station, Departure, Trip) -> Void) {
        BartStationService.getAllStations() { stations in
            let destination = stations.first(where: { station in station.abbr == departure.abbreviation })!
            BartScheduleService.getTripPlan(from: self.fromStation, to: destination, count: 12) { trips in
                let trip = DataUtil.findClosestTrip(in: trips, for: departure)
                completionHandler(self.fromStation, destination, departure, trip!)
            }
        }
    }

    private func retrieveDeparture(by trip: Trip, completionHandler: @escaping (Station,  Station, Departure, Trip) -> Void) {
        BartRealTimeService.getSelectedDepartures(for: self.fromStation) { departures in
//            BartRouteService.getAllRoutes() { routes in
//                let dep = DataUtil.findClosestDeparture(in: departures, for: trip, with: )
//                completionHandler(self.fromStation, self.toStation!, dep!, trip)
//            }

        }
    }
}
