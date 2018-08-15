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
    var stations: [StationTime] = []

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
        self.selectionStyle = .none
        
        self.minute = UILabel()
        self.minute.translatesAutoresizingMaskIntoConstraints = false
        self.minute.layer.cornerRadius = 25
        self.minute.textAlignment = .center
        self.addSubview(self.minute)

        self.destLabel = UILabel()
        self.destLabel.translatesAutoresizingMaskIntoConstraints = false
        self.destLabel.font = UIFont(name: self.destLabel.font.fontName, size: 20)
        self.destLabel.adjustsFontSizeToFitWidth = true
        self.destLabel.minimumScaleFactor = 0.5
        self.addSubview(self.destLabel)

        NSLayoutConstraint.activate([
            self.minute.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.minute.topAnchor.constraint(greaterThanOrEqualTo: self.safeArea.topAnchor, constant: 10),
            self.minute.bottomAnchor.constraint(lessThanOrEqualTo: self.safeArea.bottomAnchor, constant: -10),
            self.minute.widthAnchor.constraint(equalToConstant: 50),
            self.minute.heightAnchor.constraint(equalToConstant: 50),
            self.destLabel.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 15),
            self.destLabel.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.destLabel.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.destLabel.heightAnchor.constraint(equalToConstant: 25),
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
            self.stations.forEach({ station in station.removeFromSuperview() })
            self.stations = []
            var previous = self.destLabel.bottomAnchor
            let stations = DataUtil.clipStations(for: self.trip)
            for stnt in stations {
                let st = StationTime()
                st.loadData(
                        time: stnt.1,
                        station: stationsMap[stnt.0]?.name,
                        symbol: UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 7, height: 7), textColor: .gray, backgroundColor: .clear))
                self.addSubview(st)
                self.stations.append(st)
                NSLayoutConstraint.activate([
                    st.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 15),
                    st.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
                    st.topAnchor.constraint(equalTo: previous),
                    st.heightAnchor.constraint(equalToConstant: 20)
                ])
                previous = st.bottomAnchor
            }
            self.safeArea.bottomAnchor.constraint(greaterThanOrEqualTo: previous).isActive = true
            self.stations.first?.symbol.image = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 9, height: 9), textColor: .red, backgroundColor: .clear)
            self.stations.last?.symbol.image = UIImage(icon: .fontAwesomeSolid(.circle), size: CGSize(width: 9, height: 9), textColor: .green, backgroundColor: .clear)
        }
    }
}


class StationTime: UIView {
    var time = UILabel()
    var station = UILabel()
    var symbol = UIImageView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.time.translatesAutoresizingMaskIntoConstraints = false
        self.time.font = UIFont(name: self.time.font.fontName, size: 13)
        self.addSubview(self.time)

        self.symbol.translatesAutoresizingMaskIntoConstraints = false
        self.symbol.contentMode = .center
        self.addSubview(self.symbol)

        self.station.translatesAutoresizingMaskIntoConstraints = false
        self.station.font = UIFont(name: self.station.font.fontName, size: 13)
        self.station.adjustsFontSizeToFitWidth = true
        self.station.minimumScaleFactor = 0.5
        self.symbol.addSubview(self.station)

        NSLayoutConstraint.activate([
            self.time.topAnchor.constraint(equalTo: self.topAnchor),
            self.time.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.time.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.time.widthAnchor.constraint(equalToConstant: 60),
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
