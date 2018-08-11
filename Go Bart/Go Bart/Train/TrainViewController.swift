//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons

class TrainViewController: UIViewController {
    var trainView: TrainView!

    var fromStationData: Station!
    var toStationData: Station!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Trains"
        self.tabBarItem = UITabBarItem(title: "Train", image: UIImage(icon: .fontAwesomeSolid(.subway), size: CGSize(width: 32, height: 32)), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.trainView = TrainView(view: self.view)
        self.trainView.departureListView.refreshControl?.addTarget(self, action: #selector(updateDepartureList), for: .valueChanged)
        self.trainView.tripListView.refreshControl?.addTarget(self, action: #selector(updateTripList), for: .valueChanged)

    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor("#3359D1")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }

    @objc func pickFromStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(with: "Pick From Station") { station in
            self.trainView.updateFromStation(from: station)
            self.fromStationData = station
            self.updateDepartureList()
        }
    }

    @objc func pickToStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(with: "Pick Destination") { station in
            self.trainView.updateToStation(to: station)
            self.toStationData = station
            self.updateTripList()
        }
    }

    @objc func updateDepartureList() {
        BartRealTimeService.getSelectedDepartures(for: self.fromStationData) { departures in
            self.trainView.updateDepartureList(departures: departures) { departure in
                self.openRouteDetail(from: self.fromStationData, departure: departure)
            }
        }
    }

    @objc func updateTripList() {
        BartScheduleService.getTripPlan(from: self.fromStationData, to: self.toStationData) { trips in
            self.trainView.updateTripList(trips: trips) { trip in
                self.openRouteDetail(from: self.fromStationData, to: self.toStationData, trip: trip)
            }
        }
    }

    private func openStationPicker(with title: String, afterSelected: @escaping (Station) -> Void) {
        self.hidesBottomBarWhenPushed = true
        let target = StationPickerViewController().with(barTitle: title).onStationSelected(selectedHandler: afterSelected)
        self.show(target, sender: self)
        self.hidesBottomBarWhenPushed = false
    }

    private func openRouteDetail(from station: Station, to destination: Station? = nil, departure: Departure? = nil, trip: Trip? = nil) {
        self.present(RouteDetailNavigationViewController(
                rootViewController:RouteDetailViewController().with(from: station, to: destination, departure: departure, trip: trip)
        ), animated: true)
    }
}
