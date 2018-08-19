//
// Created by Hongfei on 2018/8/14.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailContentList: UITableView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    var station: Station!
    var destination: Station?
    var departure: Departure?
    var trip: Trip?
    var mapView: RouteDetailMapView!
    var legStations: [String:[Station]] = [:]
    var legRouteDetails: [String: DetailRoute] = [:]

    var parentControllerView: UINavigationController? {
        didSet {
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragToDismiss))
            panRecognizer.delegate = self
            parentControllerView?.view.addGestureRecognizer(panRecognizer)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

        self.delegate = self
        self.dataSource = self
        self.bounces = false

        self.register(RouteDetailMapView.self, forCellReuseIdentifier: "RouteDetailMapView")
        self.register(SingleTripView.self, forCellReuseIdentifier: "SingleTripView")
    }

    func reloadRouteDetail(from station: Station, to destination: Station?, with departure: Departure?, of trip: Trip?) {
        self.station = station
        self.destination = destination
        self.departure = departure
        self.trip = trip

        if let actualTrip = trip {
            for leg in actualTrip.leg {
                BartRouteService.getDetailRouteInfo(with: leg.line) { routeDetail in
                    DataUtil.extractStations(for: routeDetail, from: leg.origin, to: leg.destination) { stations in
                        self.legStations[leg.order] = stations
                        self.legRouteDetails[leg.order] = routeDetail
                        self.reloadData()
                    }
                }
            }
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if let actualTrip = self.trip {
                return actualTrip.leg.count
            } else {
                return 0
            }
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.frame.width / 3 * 2
        case 1:
            if let legends = self.trip?.leg {
                let leg = legends[indexPath.row]
                if let stations = self.legStations[leg.order] {
                    let height = CGFloat(stations.count * 25 + 50)
                    return height
                }
            }
            return 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RouteDetailMapView") as? RouteDetailMapView {
                self.mapView = cell
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTripView") as? SingleTripView {
                guard let legends = self.trip?.leg else {
                    return UITableViewCell()
                }

                let leg = legends[indexPath.row]
                if let stations = self.legStations[leg.order], let routeDetail = self.legRouteDetails[leg.order] {
                    self.mapView.showStations(stations: stations)
                    cell.reloadData(with: stations, legend: leg, route: routeDetail)
                }

                return cell
            }

        default:
            return UITableViewCell()
        }
    }

    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var initialViewFrame: CGRect!
    var isPanEnabled: Bool = true
    var firstTouchInsideMap: Bool = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.isPanEnabled = scrollView.contentOffset.y == 0
        self.bounces = !self.isPanEnabled
    }

    @IBAction func dragToDismiss(_ recognizer: UIPanGestureRecognizer) {
        guard let navController = self.parentControllerView, let view = navController.view else {
            return
        }

        if !self.isPanEnabled { return }

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let barHeight = navController.navigationBar.frame.height + statusBarHeight
        let touchPoint = recognizer.location(in: view.window)
        let mapFrame = self.mapView.frame

        if recognizer.state == .began {
            self.initialTouchPoint = touchPoint
            self.initialViewFrame = view.frame
            self.firstTouchInsideMap = mapFrame.minY + barHeight < touchPoint.y && touchPoint.y < mapFrame.maxY + barHeight
            self.isScrollEnabled = !self.firstTouchInsideMap
        } else if recognizer.state == .changed {
            if self.firstTouchInsideMap { return }
            self.bounces = touchPoint.y < initialTouchPoint.y
            if touchPoint.y - initialTouchPoint.y > 0 {
                view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y + statusBarHeight, width: view.frame.size.width, height: view.frame.size.height)
            }
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            self.isScrollEnabled = true
            if self.firstTouchInsideMap { return }
            if touchPoint.y - initialTouchPoint.y > 100 {
                navController.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    view.frame = self.initialViewFrame
                })
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
