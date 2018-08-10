//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {
    var trainView: TrainView!

    var fromStationData: Station?
    var toStationData: Station?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Trains"
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        self.tabBarItem.title = "Trains"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.trainView = TrainView(view: self.view)
        self.trainView.addFromGesture(gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(pickFromStation)))
        self.trainView.addToGesture(gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(pickToStation)))
//        self.trainView.onTrainSelected()
    }

    @objc func pickFromStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(with: "Pick From Station") { station in
            self.trainView.updateFromStation(from: station)
            BartRealTimeService.getDepartures(for: station) { departures in
                self.trainView.displayDepartureList(departures: departures) { departure in
                    self.openRouteDetail(from: station, with: departure)
                }
            }
        }
    }

    @objc func pickToStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(with: "Pick To Station") { station in
            self.trainView.upToStation(to: station)
        }
    }

    private func openStationPicker(with title: String, afterSelected: @escaping (Station) -> Void) {
        self.hidesBottomBarWhenPushed = true
        let target = StationPickerViewController().with(barTitle: title).onStationSelected(selectedHandler: afterSelected)
        self.show(target, sender: self)
        self.hidesBottomBarWhenPushed = false
    }

    private func openRouteDetail(from station: Station, with departure: Departure) {
        self.present(RouteDetailNavigationViewController(
                rootViewController: RouteDetailViewController().with(from: station, departure: departure)
        ), animated: true)
    }
}
