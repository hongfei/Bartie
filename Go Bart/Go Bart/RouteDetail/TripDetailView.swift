//
// Created by Hongfei on 2018/8/13.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift


class SingleTripView: UITableViewCell {
    var safeArea: UILayoutGuide!

    var orderLabel = UILabel()
    var trainIcon = UIImageView()
    var trainDestinationLabel = UILabel()
    var departStation: StationTime = StationTime()
    var destinationStation: StationTime = StationTime()
    var middleStations: [StationTime] = []
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        self.safeArea = self.contentView.safeAreaLayoutGuide

        self.orderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.orderLabel)

        self.trainIcon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.trainIcon)

        self.trainDestinationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.trainDestinationLabel)

        NSLayoutConstraint.activate([
            self.orderLabel.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.orderLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.orderLabel.widthAnchor.constraint(equalToConstant: 30),
            self.orderLabel.heightAnchor.constraint(equalToConstant: 30),
            self.trainIcon.leadingAnchor.constraint(equalTo: self.orderLabel.trailingAnchor),
            self.trainIcon.topAnchor.constraint(equalTo: self.safeArea.topAnchor, constant: 5),
            self.trainIcon.widthAnchor.constraint(equalToConstant: 20),
            self.trainIcon.heightAnchor.constraint(equalToConstant: 20),
            self.trainIcon.bottomAnchor.constraint(lessThanOrEqualTo: self.orderLabel.bottomAnchor),
            self.trainDestinationLabel.leadingAnchor.constraint(equalTo: self.trainIcon.trailingAnchor, constant: 5),
            self.trainDestinationLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.trainDestinationLabel.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.trainDestinationLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func reloadData(with stations: [Station], legend: Legend, route: DetailRoute) {
        self.orderLabel.text = legend.order

        BartStationService.getAllStationMap() { stationsMap in
            self.trainDestinationLabel.text = stationsMap[legend.trainHeadStation]?.name
        }

        self.trainIcon.image = UIImage(icon: .fontAwesomeSolid(.train), size: CGSize(width: 20, height: 20), textColor: UIColor(route.hexcolor), backgroundColor: UIColor.white)
        let stationSymbol = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 9, height: 9), textColor: UIColor(route.hexcolor), backgroundColor: UIColor.clear)

        var previous = self.trainDestinationLabel.bottomAnchor
        for station in stations {
            let st = StationTime()
            st.loadData(time: "", station: station.name, symbol: stationSymbol)
            self.contentView.addSubview(st)
            NSLayoutConstraint.activate([
                st.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
                st.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
                st.topAnchor.constraint(equalTo: previous),
                st.heightAnchor.constraint(equalToConstant: 25)
            ])
            previous = st.bottomAnchor
        }

        self.safeArea.bottomAnchor.constraint(greaterThanOrEqualTo: previous).isActive = true
    }
}
