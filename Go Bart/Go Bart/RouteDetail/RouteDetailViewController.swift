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
//        let gestureRecognizer = UIPanGestureRecognizer(target: self,
//                action: #selector(panGestureRecognizerHandler(_:)))
//        self.view.addGestureRecognizer(gestureRecognizer)
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

class RouteDetailViewController: UIViewController {
    var fromStation: Station!
    var toStation: Station?
    var departure: Departure?
    var trip: Trip?

    var stationMap: RouteDetailMapView!
    var tripDetailView: TripDetailView!
    var scrollView: UIScrollView!
    var contentView: UIView!

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
        self.view.backgroundColor = UIColor.clear

        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.isScrollEnabled = true
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.scrollView.addSubview(self.contentView)
        self.view.addSubview(self.scrollView)

        self.stationMap = RouteDetailMapView()
        self.contentView.addSubview(self.stationMap)

        self.tripDetailView = TripDetailView()
        self.contentView.addSubview(self.tripDetailView)

        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.trailingAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor),
            self.stationMap.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stationMap.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stationMap.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stationMap.heightAnchor.constraint(equalToConstant: self.view.frame.size.width / 3 * 2),
            self.tripDetailView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
            self.tripDetailView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
            self.tripDetailView.topAnchor.constraint(equalTo: self.stationMap.bottomAnchor),
            self.tripDetailView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.safeAreaLayoutGuide.bottomAnchor)
        ])

        retrieveMissingData() { (station, destination, departure, trip) in
            self.initializeView(from: station, to: destination, with: departure, of: trip)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.contentView.frame.size.height)
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

    private func initializeView(from station: Station, to destination: Station, with departure: Departure?, of trip: Trip) {
        self.tripDetailView.initializeLegendCount(of: trip.leg.count)
        trip.leg.forEach({ leg in
            BartRouteService.getAllRoutes() { routes in
                if let route = routes.first(where: { route in route.routeID == leg.line }) {
                    BartRouteService.getDetailRouteInfo(for: route) { routeDetail in
                        DataUtil.extractStations(for: routeDetail, from: leg.origin, to: leg.destination) { stations in
                            self.tripDetailView.addTrip(legend: leg, stations: stations, route: routeDetail)
                            self.stationMap.showStations(stations: stations)
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
