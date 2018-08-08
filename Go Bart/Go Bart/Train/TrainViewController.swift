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
    }

    @objc func pickFromStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(with: "Pick From Station") { station in
            self.trainView.updateFromStation(from: station)
            BartScheduleService.getDepartureTime(for: station) { estimatedDepartures in
                estimatedDepartures.map { departure in
                    debugPrint(departure.destination)
                    for est in departure.estimate {
                        debugPrint(est.minutes)
                    }
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
        let target = ViewControllerManager.getViewController(of: StationPickerViewController.self)
                .withBarTitle(of: title).onStationSelected(selectedHandler: afterSelected)
        self.present(UINavigationController(rootViewController: target), animated: true)
    }
}
