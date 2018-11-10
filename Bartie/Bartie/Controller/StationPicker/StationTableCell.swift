//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hon????gfei Zhou. All rights reserved.
//
import UIKit
import PinLayout

class StationTableCell: UITableViewCell {
    public static let HEIGHT = CGFloat(60)
    var station: Station!
    var name: UILabel = UILabel()
    var county: UILabel = UILabel()
    var address: UILabel = UILabel()

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(5, 20, 5, 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white

        name.font = FontUtil.pingFangTCRegular(size: 17)
        self.addSubview(name)

        county.font = FontUtil.pingFangTCRegular(size: 10)
        county.textAlignment = .right
        self.addSubview(county)

        address.font = FontUtil.pingFangTCRegular(size: 10)
        self.addSubview(address)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.name.pin.horizontally(pin.safeArea).top(pin.safeArea).height(30)
        self.county.pin.below(of: self.name, aligned: .right).marginTop(5).width(80).height(15)
        self.address.pin.below(of: self.name, aligned: .left).marginTop(5).before(of: self.county).marginRight(0).height(15)
    }

    func reloadStation() {
        self.name.text = self.station.name
        self.address.text = self.station.address
        if let mappedCountyName = Settings.stationNameMapping[self.station.county] {
            self.county.text = mappedCountyName
        } else {
            self.county.text = self.station.county
        }
    }
}
