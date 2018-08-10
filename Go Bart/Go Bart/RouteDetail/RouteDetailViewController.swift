//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

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
    var departure: Departure!
    var station: Station!

    var stationList: UITextView!

    override var navigationItem: UINavigationItem {
        let navItem = UINavigationItem(title: self.departure.destination!)
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

        BartRouteService.getAllRoutes() { routes in
            if let route = routes.first(where: { route in route.hexcolor == self.departure.hexcolor }) {
                BartRouteService.getDetailRouteInfo(for: route) { routeDetail in
                    let stations = routeDetail.config.station
                    let start = stations.index(of: self.station.abbr)!
                    let end = stations.index(of: self.departure.abbreviation!)!
                    var choppedStations: [String] = []
                    if start < end {
                        choppedStations = Array(stations[start...end])
                    } else {
                        choppedStations = Array(stations[end...start]).reversed()
                    }
                    self.stationList.text = choppedStations.joined(separator: "\n")
                }
            }
        }
    }

    @objc func closeRouteDetail() {
        self.dismiss(animated: true)
    }

    func with(from station: Station, departure: Departure) -> RouteDetailViewController {
        self.departure = departure
        self.station = station
        return self
    }
}
