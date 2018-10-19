//
// Created by Hongfei on 2018/8/10.
// Copyrigh?t ??(c) 2018? Hongfei ?Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons
import PinLayout

class TripListCell: UITableViewCell {
    var trip: Trip!
    var station: Station!
    var destination: Station!
    var departure: Departure?

    var minute: UILabel = UILabel()
    var destLabel: UILabel = UILabel()
    var stations: [StationTime] = []

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 15)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.minute.layer.cornerRadius = 25
        self.minute.textAlignment = .center
        self.addSubview(self.minute)

        self.destLabel.font = UIFont(name: self.destLabel.font.fontName, size: 20)
        self.destLabel.adjustsFontSizeToFitWidth = true
        self.destLabel.minimumScaleFactor = 0.5
        self.addSubview(self.destLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.minute.pin.height(50).width(50).left(pin.safeArea).vCenter()
        self.destLabel.pin.after(of: self.minute).marginLeft(10).top(pin.safeArea).right(pin.safeArea).height(30)

        var previous: UIView = self.destLabel
        for st in self.stations {
            st.pin.below(of: previous, aligned: .left).marginTop(0).right(self.pin.safeArea).height(20)
            previous = st
        }
    }

    func reloadTripData() {
        if let dep = self.departure {
            self.minute.text = dep.minutes
            self.minute.layer.backgroundColor = UIColor(dep.hexcolor).cgColor
        } else {
            var timeDiff = DateUtil.getTimeDifferenceToNow(dateString: self.trip.origTimeDate + self.trip.origTimeMin)
            timeDiff = timeDiff > 0 ? timeDiff : 0
            self.minute.text = String(timeDiff)
            BartRouteService.getAllRoutes() { routes in
                if let leg = self.trip.leg.first, let route = routes.first(where: {route in route.routeID == leg.line}) {
                    self.minute.layer.backgroundColor = UIColor(route.hexcolor).cgColor
                }
            }
        }

        StationService.getAllStationMap() { stationsMap in
            if let leg = self.trip.leg.first, let headStation = stationsMap[leg.trainHeadStation] {
                self.destLabel.text = headStation.name
            }

            self.stations.forEach({ station in station.removeFromSuperview() })
            self.stations = []
            let stations = DataUtil.clipStations(for: self.trip)
            for stnt in stations {
                let st = StationTime()
                st.loadData(
                        time: stnt.1,
                        station: stationsMap[stnt.0]?.name,
                        symbol: Icons.middleDot)
                self.addSubview(st)
                self.stations.append(st)
            }

            self.stations.first?.symbol.image = Icons.startDot
            self.stations.last?.symbol.image = Icons.endDot
        }
    }
}

class StationTime: UIView {
    var time = UILabel()
    var station = UILabel()
    var symbol = UIImageView()
    var toiletIcon = UIImageView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.time.font = UIFont(name: self.time.font.fontName, size: 13)
        self.addSubview(self.time)

        self.symbol.contentMode = .scaleAspectFit
        self.addSubview(self.symbol)

        self.station.font = UIFont(name: self.station.font.fontName, size: 13)
        self.station.adjustsFontSizeToFitWidth = true
        self.station.minimumScaleFactor = 0.5
        self.addSubview(self.station)

        self.toiletIcon.image = Icons.toilet
        self.addSubview(self.toiletIcon)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.time.pin.vertically(pin.safeArea).left(pin.safeArea).width(60)
        self.symbol.pin.after(of: self.time, aligned: .center).width(10).height(10)
        self.station.pin.after(of: self.symbol).marginLeft(5).right(pin.safeArea).vertically(pin.safeArea)
        self.toiletIcon.pin.before(of: self.symbol, aligned: .center).marginRight(10).width(15).height(15)
    }

    func loadData(time: String, station: String?, symbol: UIImage, stationProperty: StationProperty? = nil) {
        self.time.text = time
        self.station.text = station
        self.symbol.image = symbol
        self.toiletIcon.isHidden = stationProperty == nil || !stationProperty!.hasToilet
    }
}
