//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {
    var safeArea: UILayoutGuide!

    var fromLabel: FromStationLabel!
    var fromStation: FromStation!
    var toLabel: ToStationLabel!
    var toStation: ToStation!

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
        fromLabel = FromStationLabel()
        self.view.addSubview(fromLabel)

        NSLayoutConstraint.activate([
            fromLabel.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            fromLabel.widthAnchor.constraint(equalToConstant: 60),
            fromLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            fromLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    public func placeFromStation() {
        fromStation = FromStation()
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
        toLabel = ToStationLabel()
        self.view.addSubview(toLabel)

        NSLayoutConstraint.activate([
            toLabel.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            toLabel.widthAnchor.constraint(equalToConstant: 60),
            toLabel.heightAnchor.constraint(equalTo: fromLabel.heightAnchor)
        ])
    }

    public func placeToStation() {
        toStation = ToStation()
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
        self.openStationPicker(withTitle: "Pick From Station")
    }

    @objc func pickToStation(_ sender: UIGestureRecognizer) {
        self.openStationPicker(withTitle: "Pick To Station")
    }

    func openStationPicker(withTitle: String) {
        let target = UINavigationController(rootViewController: StationPickerViewController(barTitle: withTitle))
        self.present(target, animated: true)
    }
}
