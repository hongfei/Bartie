//
//  DepartureListCell.swift
//  Go Bart
//
//  Created by Ho?ngfei on 2018/8/8.
//  Copyrig?ht © ?2018?年 Hong?fei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons
import PinLayout

class DepartureListCell: UITableViewCell {
    public static let HEIGHT = CGFloat(70)
    var departure: Departure!

    var destination: UILabel = UILabel()
    var minute: UILabel = UILabel()
    var platform: UILabel = UILabel()
    var length: UILabel = UILabel()
    var delay: UILabel = UILabel()

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 5)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.minute.layer.cornerRadius = 25
        self.minute.textAlignment = .center
        self.addSubview(self.minute)

        self.destination.font = UIFont(name: self.destination.font.fontName, size: 20)
        self.destination.adjustsFontSizeToFitWidth = true
        self.destination.minimumScaleFactor = 0.5
        self.addSubview(self.destination)

        self.length.font = UIFont(name: self.length.font.fontName, size: 15)
        self.addSubview(self.length)

        self.platform.font = UIFont(name: self.platform.font.fontName, size: 15)
        self.addSubview(self.platform)

        self.delay.font = UIFont(name: self.delay.font.fontName, size: 15)
        self.delay.isHidden = true
        self.addSubview(self.delay)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.minute.pin.vertically(pin.safeArea).left(pin.safeArea).height(50).width(50)
        self.platform.pin.top(pin.safeArea).right(pin.safeArea).width(95).height(15)
        self.length.pin.below(of: self.platform, aligned: .right).width(of: self.platform).height(15)
        self.delay.pin.below(of: self.length, aligned: .right).width(of: self.platform).height(15)
        self.destination.pin.after(of: self.minute, aligned: .center).marginLeft(10).before(of: self.length).marginRight(5).height(30)
    }

    func setDeparture(departure: Departure) {
        self.departure = departure
        reloadDepartureData()
    }

    private func reloadDepartureData() {
        self.minute.text = self.departure.minutes
        self.minute.layer.backgroundColor = UIColor(self.departure.hexcolor).cgColor
        self.destination.text = self.departure.destination
        self.length.text = self.departure.length + " cars"
        self.platform.text = "Platform " + self.departure.platform
        if let delay = Int(self.departure.delay) {
            self.delay.text = "Delay: " + String(delay / 60) + " min"
        }
        self.delay.isHidden = self.departure.delay == "0"
    }
}
