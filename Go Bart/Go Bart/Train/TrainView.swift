//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainView {
    let view: UIView!
    let safeArea: UILayoutGuide!

    var fromLabel: FromStationLabel = FromStationLabel()
    var fromStation: FromStation = FromStation()
    var toLabel: ToStationLabel = ToStationLabel()
    var toStation: ToStation! = ToStation()

    init(view: UIView) {
        self.view = view

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
        fromStation.addGestureRecognizer(UITapGestureRecognizer(
                target: ViewControllerManager.getViewController(of: TrainViewController.self),
                action: #selector(TrainViewController.pickFromStation)
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
        toStation.addGestureRecognizer(UITapGestureRecognizer(
                target: ViewControllerManager.getViewController(of: TrainViewController.self),
                action: #selector(TrainViewController.pickToStation)
        ))
        self.view.addSubview(toStation)

        NSLayoutConstraint.activate([
            toStation.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor),
            toStation.topAnchor.constraint(equalTo: fromStation.bottomAnchor),
            toStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            toStation.heightAnchor.constraint(equalTo: toLabel.heightAnchor)
        ])
    }

    func updateFromStation(from station: Station) {
        self.fromStation.text = station.name
    }

    func upToStation(to station: Station) {
        self.toStation.text = station.name
    }

    func addFromGesture(gestureRecognizer: UIGestureRecognizer) {
        self.fromStation.addGestureRecognizer(gestureRecognizer)
    }

    func addToGesture(gestureRecognizer: UIGestureRecognizer) {
        self.toStation.addGestureRecognizer(gestureRecognizer)
    }

}
