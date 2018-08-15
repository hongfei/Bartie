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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                action: #selector(panGestureRecognizerHandler(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }


    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
            initialFramePoint = self.navigationBar.frame.origin
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = initialFramePoint.y + (touchPoint.y - initialTouchPoint.y)
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                            y: 0,
                            width: self.view.frame.size.width,
                            height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
}

class RouteDetailViewController: UITableViewController {
    var fromStation: Station!
    var toStation: Station?
    var departure: Departure?
    var trip: Trip?

    var legends: [Legend] = []
    var allStations: [Station] = []
    var legendStations: [[Station]] = []
    var legendRoutes: [DetailRoute] = []

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
        self.extendedLayoutIncludesOpaqueBars = false
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(RouteDetailMapView.self, forCellReuseIdentifier: "RouteDetailMapView")
        self.tableView.register(SingleTripView.self, forCellReuseIdentifier: "SingleTripView")

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveMissingData() { (station, destination, departure, trip) in
            self.initializeView(from: station, to: destination, with: departure, of: trip)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return self.legends.count
        default: return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteDetailMapView") as! RouteDetailMapView
            cell.showStations(stations: self.allStations)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTripView") as! SingleTripView
            cell.reloadData(with: self.legendStations[indexPath.row], legend: self.legends[indexPath.row], route: self.legendRoutes[indexPath.row])

            return cell
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }


    @IBAction func closeRouteDetail() {
        self.dismiss(animated: true)
    }

    func with(from station: Station, to destination: Station! = nil, departure: Departure! = nil, trip: Trip! = nil) -> RouteDetailViewController {
        self.fromStation = station
        self.toStation = destination
        self.departure = departure
        self.trip = trip

        return self
    }

    private func initializeView(from station: Station, to destination: Station, with departure: Departure?, of trip: Trip) {
        self.legends = trip.leg
        trip.leg.forEach({ leg in
            BartRouteService.getAllRoutes() { routes in
                if let route = routes.first(where: { route in route.routeID == leg.line }) {
                    BartRouteService.getDetailRouteInfo(for: route) { routeDetail in
                        self.legendRoutes.append(routeDetail)
                        DataUtil.extractStations(for: routeDetail, from: leg.origin, to: leg.destination) { stations in
                            self.legendStations.append(stations)
                            self.allStations.append(contentsOf: stations.dropFirst())
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        })
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
