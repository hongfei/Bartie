//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TripListCell: UITableViewCell {
    var trip: Trip!

    var destination: UILabel!

    var safeArea: UILayoutGuide!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 15)
    }

    func initializeCell() {
        self.safeArea = self.safeAreaLayoutGuide

        self.destination = UILabel()
        self.destination.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.destination)

        NSLayoutConstraint.activate([
            self.destination.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.destination.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.destination.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.destination.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor)
        ])
    }

    func setTrip(trip: Trip) {
        self.trip = trip
        reloadTripData()
    }

    private func reloadTripData() {
        var str = ""
        for legend in self.trip.leg {
            str += legend.origin + "->" + legend.destination
            str += " "
        }
        self.destination.text = str + " "
    }
}
