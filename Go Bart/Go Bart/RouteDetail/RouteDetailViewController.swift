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

        retrieveMissingData() { (from, to, departure, trip) in
            self.stationList.text = departure.minutes + " == " + trip.origTimeMin
            BartRouteService.getAllRoutes() { routes in
                if let route = routes.first(where: { route in route.hexcolor == departure.hexcolor }) {
                    BartRouteService.getDetailRouteInfo(for: route) { routeDetail in
                        let stations = routeDetail.config.station
                        let start = stations.index(of: from.abbr)!
                        let end = stations.index(of: to.abbr)!
                        var choppedStations: [String] = []
                        if start < end {
                            choppedStations = Array(stations[start...end])
                        } else {
                            choppedStations = Array(stations[end...start]).reversed()
                        }
                        self.stationList.text = self.stationList.text + "\n" + choppedStations.joined(separator: "\n")
                    }
                }
            }
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
                let trip = trips.filter({ trip in
                    trip.leg.first!.trainHeadStation == departure.abbreviation
                }).min(by: { (trip1, trip2) in
                    let tripDiff1 = DateUtil.getTimeDifferenceToNow(dateString: trip1.origTimeDate + trip1.origTimeMin)
                    let tripDiff2 = DateUtil.getTimeDifferenceToNow(dateString: trip2.origTimeDate + trip2.origTimeMin)
                    return abs(tripDiff1 - Int(departure.minutes)!) < abs(tripDiff2 - Int(departure.minutes)!)
                })
                completionHandler(self.fromStation, destination, departure, trip!)
            }
        }
    }

    private func retrieveDeparture(by trip: Trip, completionHandler: @escaping (Station,  Station, Departure, Trip) -> Void) {
        BartRealTimeService.getSelectedDepartures(for: self.fromStation) { departures in
            let dep = departures.filter({ departure in
                return departure.abbreviation == trip.leg.first?.trainHeadStation
            }).min(by: { (dep1, dep2) in
                let tripDiff = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
                return abs(Int(dep1.minutes)! - tripDiff) < abs(Int(dep2.minutes)! - tripDiff)
            })
            completionHandler(self.fromStation, self.toStation!, dep!, trip)
        }
    }
}
