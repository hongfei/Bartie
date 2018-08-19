//
// Created by Hongfei on 2018/8/13.
// Copyright (c) 2018 Ho?ngfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift
import PinLayout


class SingleTripView: UITableViewCell {
    var orderLabel: UILabel = UILabel()
    var trainIcon: UIImageView = UIImageView()
    var trainDestinationLabel: UILabel = UILabel()

    var stations: [StationTime] = []

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = false
        
        self.addSubview(self.orderLabel)
        self.addSubview(self.trainIcon)
        self.addSubview(self.trainDestinationLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.orderLabel.pin.left(pin.safeArea).top(pin.safeArea).width(30).height(30)
        self.trainIcon.pin.after(of: self.orderLabel, aligned: .center).marginLeft(5).width(20).height(20)
        self.trainDestinationLabel.pin.after(of: self.trainIcon, aligned: .center).marginLeft(5).right(pin.safeArea).height(30)

        var previous: UIView = self.trainDestinationLabel
        for st in self.stations {
            st.pin.horizontally(pin.safeArea).below(of: previous).marginTop(0).height(25)
            previous = st
        }
    }

    func reloadData(with stations: [Station], legend: Legend, route: DetailRoute) {
        self.stations.forEach({ st in st.removeFromSuperview() })
        self.stations = []
        self.orderLabel.text = legend.order

        BartStationService.getAllStationMap() { stationsMap in
            self.trainDestinationLabel.text = stationsMap[legend.trainHeadStation]?.name
        }

        self.trainIcon.image = Icons.train(of: UIColor(route.hexcolor))
        let stationSymbol = Icons.dot(of: UIColor(route.hexcolor))

        for station in stations {
            let st = StationTime()
            st.loadData(time: "", station: station.name, symbol: stationSymbol)
            self.addSubview(st)
            self.stations.append(st)
        }
        self.stations.first?.time.text = legend.origTimeMin
        self.stations.last?.time.text = legend.destTimeMin
    }
}
