//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {
    var safeArea: UILayoutGuide!

    var fromLabel: FromStationLabel = FromStationLabel()
    var fromStation: FromStation = FromStation()
    var toLabel: ToStationLabel = ToStationLabel()
    var toStation: ToStation! = ToStation()

    var fromStationData: Station?
    var toStationData: Station?

    var stationPicker: StationPickerViewController = StationPickerViewController()

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
        self.safeArea = self.view.safeAreaLayoutGuide
        self.view.backgroundColor = UIColor.white

        placeFromLabel()
        placeFromStation()
        placeToLabel()
        placeToStation()
    }

    private func placeFromLabel() {
        self.view.addSubview(fromLabel)

        NSLayoutConstraint.activate([
            fromLabel.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            fromLabel.widthAnchor.constraint(equalToConstant: 60),
            fromLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            fromLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    public func placeFromStation() {
        fromStation.text = fromStationData?.name
        fromStation.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(pickFromStation)
        ))
        self.view.addSubview(fromStation)

        NSLayoutConstraint.activate([
            fromStation.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor),
            fromStation.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            fromStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            fromStation.heightAnchor.constraint(equalTo: fromLabel.heightAnchor)
        ])
    }

    public func placeToLabel() {
        self.view.addSubview(toLabel)

        NSLayoutConstraint.activate([
            toLabel.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            toLabel.widthAnchor.constraint(equalToConstant: 60),
            toLabel.heightAnchor.constraint(equalTo: fromLabel.heightAnchor)
        ])
    }

    public func placeToStation() {
        toStation.text = toStationData?.name
        toStation.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(pickToStation)
        ))
        self.view.addSubview(toStation)

        NSLayoutConstraint.activate([
            toStation.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor),
            toStation.topAnchor.constraint(equalTo: fromStation.bottomAnchor),
            toStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            toStation.heightAnchor.constraint(equalTo: toLabel.heightAnchor)
        ])
    }

    @objc func pickFromStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(with: "Pick From Station") { station in
            self.fromStation.text = station.name
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
            self.toStation.text = station.name
        }
    }

    private func openStationPicker(with title: String, afterSelected: @escaping (Station) -> Void) {
        let target = stationPicker.withBarTitle(of: title).onStationSelected(selectedHandler: afterSelected)
        self.present(UINavigationController(rootViewController: target), animated: true)
    }
}
