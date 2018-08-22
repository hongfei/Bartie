//
// Created by Hongfei on 2018/8/19.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FavoriteDetailNavigationViewController: UINavigationController {
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
}

class FavoriteDetailViewController: UITableViewController {
    var trip: Trip?
    var departure: Departure?
    var favorite: Favorite?
    var detourDeparture: Departure?

    var exchangeStation: Station?
    var detourTime: Int = 0
    var targetTime: Int = 999

    override var navigationItem: UINavigationItem {
        let navItem: UINavigationItem = UINavigationItem(title: "Detour Route (slow)")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeFavoriteDetail))
        return navItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CurrentStation.self, forCellReuseIdentifier: "CurrentStation")
        self.tableView.register(DetourRoute.self, forCellReuseIdentifier: "DetourRoute")

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        calculateDetourRoute()
    }

    func calculateDetourRoute() {
        guard let actualFavorite = self.favorite, let actualDeparture = self.departure, let _ = self.trip,
                let targetTime = Int(actualDeparture.minutes) else {
            return
        }
        self.targetTime = targetTime
        self.exchangeStation = actualFavorite.station
        let targetDirection = actualDeparture.direction == "South" ? "North": "South"
        BartRealTimeService.getSelectedDepartures(for: actualFavorite.station) { departures in
            guard let detourDep = departures.filter({ dep in dep.direction == targetDirection }).first,
                    let detourDepAbbr = detourDep.abbreviation,
                    let detourTime = Int(detourDep.minutes) else {
                return
            }
            self.detourDeparture = detourDep
            self.detourTime = detourTime
            BartStationService.getAllStationMap() { stationMap in
                guard let destination = stationMap[detourDepAbbr] else { return }
                BartScheduleService.getTripPlan(from: actualFavorite.station, to: destination, count: 2) { trips in
                    guard let detourTrip = trips.first, let leg = detourTrip.leg.first else { return }
                    BartRouteService.getDetailRouteInfo(with: leg.line) { detail in
                        guard let routeDetail = detail else { return }
                        DataUtil.extractStations(for: routeDetail, from: leg.origin, to: leg.destination) { stations in
                            self.pickStation(from: Array(stations.dropFirst()), from: detourDep.abbreviation!, to: actualDeparture.abbreviation!)
                        }
                    }
                }
            }
        }
    }

    func pickStation(from stations: [Station], from depAbbr: String, to targetAbbr: String) {
        if let first = stations.first {
            BartRealTimeService.getSelectedDepartures(for: first) { departures in
                if let newDep = departures.first(where: { dep in dep.abbreviation == depAbbr && Int(dep.minutes)! >= self.detourTime }),
                    let newTarget = departures.filter({ dep in dep.abbreviation == targetAbbr && Int(dep.minutes)! <= self.targetTime }).last {
                    let detourTime = Int(newDep.minutes)!
                    let targetTime = Int(newTarget.minutes)!
                    if detourTime + 1 < targetTime {
                        self.detourTime = detourTime
                        self.targetTime = targetTime
                        self.exchangeStation = first
                        self.pickStation(from: Array(stations.dropFirst()), from: depAbbr, to: targetAbbr)
                    } else {
                        self.tableView.reloadData()
                    }
                } else {
                    self.tableView.reloadData()
                }
            }
        } else {
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Take same train at earlier station"
        case 1: return nil
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return CurrentStation.HEIGHT
        case 1: return DetourRoute.HEIGHT
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentStation"), let currentStation = cell as? CurrentStation {
                if let actualFavorite = self.favorite {
                    currentStation.setCurrentStation(for: actualFavorite.station)
                }
                return currentStation
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetourRoute"), let detourRoute = cell as? DetourRoute,
                let actualFavorite = self.favorite {
                detourRoute.reloadCellData(current: actualFavorite.station, detour: self.detourDeparture, target: self.departure, exchange: self.exchangeStation, detourTime: self.detourTime, targetTime: self.targetTime)
                return detourRoute
            }
        default: return UITableViewCell()
        }

        return UITableViewCell()
    }


    @IBAction func closeFavoriteDetail() {
        self.dismiss(animated: true)
    }
}
