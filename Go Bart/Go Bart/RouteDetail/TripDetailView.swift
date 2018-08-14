//
// Created by Hongfei on 2018/8/13.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift

class TripDetailView: UIScrollView {
    var tripLabel = UILabel()
    var legends: [SingleTripView] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
    }

    func addTrip(legend: Legend, stations: [Station], route: DetailRoute) {
        self.legends[Int(legend.order)! - 1].reloadData(with: stations, legend: legend, route: route)
    }

    func initializeLegendCount(of number: Int) {
        self.legends.forEach({ l in l.removeFromSuperview() })
        self.legends = []
        var previous = self.topAnchor
        for _ in 0..<number {
            let st = SingleTripView()
            self.legends.append(st)
            self.addSubview(st)
            NSLayoutConstraint.activate([
                st.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                st.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                st.topAnchor.constraint(equalTo: previous)
            ])
            previous = st.bottomAnchor
        }
        self.bottomAnchor.constraint(equalTo: previous).isActive = true
    }
}

class SingleTripView: UIView {
    var orderLabel = UILabel()
    var trainIcon = UIImageView()
    var trainDestinationLabel = UILabel()
    var departStation: StationTime = StationTime()
    var destinationStation: StationTime = StationTime()
    var middleStations: [StationTime] = []

    var stations: [Station]!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.orderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.orderLabel)
        self.trainIcon.translatesAutoresizingMaskIntoConstraints = false
        self.trainIcon.image = UIImage(icon: .fontAwesomeSolid(.train), size: CGSize(width: 9, height: 9), textColor: .black, backgroundColor: UIColor.white)
        self.addSubview(self.trainIcon)
        self.trainDestinationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.trainDestinationLabel)

        NSLayoutConstraint.activate([
            self.orderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.orderLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.orderLabel.widthAnchor.constraint(equalToConstant: 30),
            self.orderLabel.heightAnchor.constraint(equalToConstant: 30),
            self.trainIcon.leadingAnchor.constraint(equalTo: self.orderLabel.trailingAnchor),
            self.trainIcon.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            self.trainIcon.widthAnchor.constraint(equalToConstant: 20),
            self.trainIcon.heightAnchor.constraint(equalToConstant: 20),
            self.trainDestinationLabel.leadingAnchor.constraint(equalTo: self.trainIcon.trailingAnchor),
            self.trainDestinationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.trainDestinationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.trainDestinationLabel.heightAnchor.constraint(equalToConstant: 30),
            self.bottomAnchor.constraint(equalTo: self.trainDestinationLabel.bottomAnchor)
        ])
    }

    func reloadData(with stations: [Station], legend: Legend, route: DetailRoute) {
        self.orderLabel.text = legend.order

        BartStationService.getAllStationMap() { stationsMap in
            self.trainDestinationLabel.text = stationsMap[legend.trainHeadStation]?.name
        }

        let stationSymbol = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 9, height: 9), textColor: UIColor(route.hexcolor), backgroundColor: UIColor.clear)

        var previous = self.orderLabel.bottomAnchor
        for station in stations {
            let st = StationTime()
            st.loadData(time: "", station: station.name, symbol: stationSymbol)
            self.addSubview(st)
            NSLayoutConstraint.activate([
                st.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                st.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                st.topAnchor.constraint(equalTo: previous),
                st.heightAnchor.constraint(equalToConstant: 25)
            ])
            previous = st.bottomAnchor
        }

        self.bottomAnchor.constraint(equalTo: previous)
    }
}
