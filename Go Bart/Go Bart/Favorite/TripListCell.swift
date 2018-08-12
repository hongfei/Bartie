//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons

class TripListCell: UITableViewCell {
    var trip: Trip!
    var station: Station!
    var destination: Station!
    var departure: Departure?

    var safeArea: UILayoutGuide!
    var minute: UILabel!
    var destLabel: UILabel!
    var departStation: StationTime!
    var destinationStation: StationTime!
    var middleStations: [StationTime] = []

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
        self.minute = UILabel()
        self.minute.translatesAutoresizingMaskIntoConstraints = false
        self.minute.layer.cornerRadius = 25
        self.minute.textAlignment = .center
        self.addSubview(self.minute)

        self.destLabel = UILabel()
        self.destLabel.translatesAutoresizingMaskIntoConstraints = false
        self.destLabel.adjustsFontSizeToFitWidth = true
        self.destLabel.minimumScaleFactor = 0.5
        self.addSubview(self.destLabel)

        self.departStation = StationTime()
        self.departStation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.departStation)

        self.destinationStation = StationTime()
        self.destinationStation.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.minute.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.minute.topAnchor.constraint(greaterThanOrEqualTo: self.safeArea.topAnchor, constant: 10),
            self.minute.bottomAnchor.constraint(lessThanOrEqualTo: self.safeArea.bottomAnchor, constant: -10),
            self.minute.widthAnchor.constraint(equalToConstant: 50),
            self.minute.heightAnchor.constraint(equalToConstant: 50),
            self.destLabel.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 10),
            self.destLabel.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.destLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.destLabel.heightAnchor.constraint(equalToConstant: 25),
            self.departStation.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 10),
            self.departStation.topAnchor.constraint(equalTo: self.destLabel.bottomAnchor),
            self.departStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.departStation.bottomAnchor.constraint(equalTo: self.destLabel.bottomAnchor, constant: 15)
        ])
    }
    
    func reloadTripData() {
        self.destLabel.text = self.destination.name
        if let dep = self.departure {
            self.minute.text = dep.minutes
            self.minute.layer.backgroundColor = UIColor(dep.hexcolor).cgColor
        } else {
            self.minute.text = String(DateUtil.getTimeDifferenceToNow(dateString: self.trip.origTimeDate + self.trip.origTimeMin))
            BartRouteService.getAllRoutes() { routes in
                let route = routes.first(where: {route in route.routeID == self.trip.leg.first!.line})!
                self.minute.layer.backgroundColor = UIColor(route.hexcolor).cgColor
            }
        }

        BartStationService.getAllStationMap() { stationsMap in
            let (first, middles, last) = DataUtil.clipStations(for: self.trip)
            self.departStation.loadData(
                    time: first.1,
                    station: self.station.name,
                    symbol: UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 7, height: 7), textColor: UIColor.red, backgroundColor: UIColor.clear)
            )
            self.middleStations.forEach({ station in station.removeFromSuperview() })
            self.middleStations = []
            var previous: StationTime = self.departStation
            for middle in middles {
                let st = StationTime()
                st.translatesAutoresizingMaskIntoConstraints = false
                self.middleStations.append(st)
                st.loadData(
                        time: middle.1,
                        station: stationsMap[middle.0]?.name,
                        symbol: UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 5, height: 5), textColor: UIColor.gray, backgroundColor: UIColor.clear)
                )
                self.addSubview(st)
                NSLayoutConstraint.activate([
                    st.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 10),
                    st.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
                    st.topAnchor.constraint(equalTo: previous.bottomAnchor),
                    st.bottomAnchor.constraint(equalTo: previous.bottomAnchor, constant: 15)
                ])
                previous = st
            }

            self.destinationStation.removeFromSuperview()
            self.destinationStation.loadData(
                    time: last.1,
                    station: self.destination.name,
                    symbol: UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 7, height: 7), textColor: UIColor.green, backgroundColor: UIColor.clear)
            )
            self.addSubview(self.destinationStation)
            NSLayoutConstraint.activate([
                self.destinationStation.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 10),
                self.destinationStation.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
                self.destinationStation.topAnchor.constraint(equalTo: previous.bottomAnchor),
                self.safeArea.bottomAnchor.constraint(greaterThanOrEqualTo: self.destinationStation.bottomAnchor)
            ])
        }
    }
}


class StationTime: UIView {
    let time = UILabel()
    let station = UILabel()
    let symbol = UIImageView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.time.translatesAutoresizingMaskIntoConstraints = false
        self.time.font = UIFont(name: self.time.font.fontName, size: 10)
        self.addSubview(self.time)

        self.symbol.translatesAutoresizingMaskIntoConstraints = false
        self.symbol.contentMode = .center
        self.symbol.safeAreaInsets
        self.addSubview(self.symbol)

        self.station.translatesAutoresizingMaskIntoConstraints = false
        self.station.font = UIFont(name: self.station.font.fontName, size: 10)
        self.symbol.addSubview(self.station)

        NSLayoutConstraint.activate([
            self.time.topAnchor.constraint(equalTo: self.topAnchor),
            self.time.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.time.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.time.widthAnchor.constraint(equalToConstant: 45),
            self.symbol.topAnchor.constraint(equalTo: self.topAnchor),
            self.symbol.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.symbol.leadingAnchor.constraint(equalTo: self.time.trailingAnchor),
            self.symbol.trailingAnchor.constraint(equalTo: self.time.trailingAnchor, constant: 15),
            self.station.leadingAnchor.constraint(equalTo: self.symbol.trailingAnchor),
            self.station.topAnchor.constraint(equalTo: self.topAnchor),
            self.station.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.station.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func loadData(time: String, station: String?, symbol: UIImage) {
        self.time.text = time
        self.station.text = station
        self.symbol.image = symbol
    }
}