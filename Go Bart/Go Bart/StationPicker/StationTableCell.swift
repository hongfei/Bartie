//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hon????gfei Zhou. All rights reserved.
//
import UIKit
import PinLayout

class StationTableCell: UITableViewCell {
    var station: Station!
    var safeArea: UILayoutGuide!
    var name: UILabel!
    var county: UILabel!
    var address: UILabel!

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(5, 20, 5, 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white

        name = UILabel()
        name.font = UIFont(name: name.font.fontName, size: 17)
        self.addSubview(name)

        county = UILabel()
        county.font = UIFont(name: county.font.fontName, size: 10)
        county.textAlignment = .right
        self.addSubview(county)

        address = UILabel()
        address.font = UIFont(name: county.font.fontName, size: 10)
        self.addSubview(address)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.name.pin.horizontally(pin.safeArea).top(pin.safeArea).height(30)
        self.address.pin.below(of: self.name, aligned: .left).marginTop(5).before(of: self.county).marginRight(0).height(15)
        self.county.pin.below(of: self.name, aligned: .right).marginTop(5).width(80).height(15)
    }

    func reloadStation() {
        self.name.text = self.station.name
        self.address.text = self.station.address
        self.county.text = self.station.county
    }
}
