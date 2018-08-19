//
// Created by Hongfei on 2018/8/15.
// C?opyright (c) ?2018 Hongfei Zh?ou.? A?ll rights reserved.?
//

import UIKit
import PinLayout
import UIColor_Hex_Swift

class FavoriteListCell: UITableViewCell {
    public static let HEIGHT = CGFloat(80)

    var minuteLabel: UILabel = UILabel()
    var trainLabel: UILabel = UILabel()
    var arrivalLabel: UILabel = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 15)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.autoresizingMask = .flexibleHeight

        let view = self.contentView

        self.minuteLabel.layer.cornerRadius = 25
        self.minuteLabel.textAlignment = .center
        view.addSubview(self.minuteLabel)

        self.trainLabel.font = UIFont(name: self.trainLabel.font.fontName, size: 20)
        self.trainLabel.adjustsFontSizeToFitWidth = true
        self.trainLabel.minimumScaleFactor = 0.5
        view.addSubview(self.trainLabel)

        self.arrivalLabel.font = UIFont(name: self.arrivalLabel.font.fontName, size: 15)
        view.addSubview(self.arrivalLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.minuteLabel.pin.left(pin.safeArea).height(50).width(50).centerLeft()
        self.trainLabel.pin.after(of: self.minuteLabel).top(pin.safeArea).marginLeft(15).height(30).right(pin.safeArea)
        self.arrivalLabel.pin.below(of: self.trainLabel, aligned: .left).width(of: self.trainLabel).height(20)
    }

    func reloadData(with departure: Departure?, of trip: Trip, for favorite: Favorite) {
        if let dep = departure {
            self.minuteLabel.text = dep.minutes
            self.minuteLabel.layer.backgroundColor = UIColor(dep.hexcolor).cgColor
            self.trainLabel.text = dep.destination
        } else {
            self.minuteLabel.text = String(DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin))
            BartRouteService.getAllRoutes() { routes in
                if let leg = trip.leg.first, let route = routes.first(where: {route in route.routeID == leg.line}) {
                    self.minuteLabel.layer.backgroundColor = UIColor(route.hexcolor).cgColor
                }
            }
            BartStationService.getAllStationMap() { stationsMap in
                if let leg = trip.leg.first, let station = stationsMap[leg.trainHeadStation] {
                    self.trainLabel.text = station.name
                }
            }
        }

        self.arrivalLabel.text = "Arrival: " + trip.destTimeMin
    }
}
