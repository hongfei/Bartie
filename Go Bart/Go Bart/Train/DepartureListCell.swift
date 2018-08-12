//
//  DepartureListCell.swift
//  Go Bart
//
//  Created by Hongfei on 2018/8/8.
//  Copyright © 2018年 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons

class DepartureListCell: UITableViewCell {
    var departure: Departure!

    var destination: UILabel!
    var minute: UILabel!
    var platform: UILabel!
    var length: UILabel!
    var bikeflag: UIImageView!
    var delay: UILabel!

    var safeArea: UILayoutGuide!

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

        self.destination = UILabel()
        self.destination.translatesAutoresizingMaskIntoConstraints = false
        self.destination.font = UIFont(name: self.destination.font.fontName, size: 20)
        self.addSubview(self.destination)

        self.length = UILabel()
        self.length.translatesAutoresizingMaskIntoConstraints = false
        self.length.font = UIFont(name: self.length.font.fontName, size: 15)
        self.addSubview(self.length)

        self.platform = UILabel()
        self.platform.translatesAutoresizingMaskIntoConstraints = false
        self.platform.font = UIFont(name: self.platform.font.fontName, size: 15)
        self.addSubview(self.platform)

        self.delay = UILabel()
        self.delay.translatesAutoresizingMaskIntoConstraints = false
        self.delay.font = UIFont(name: self.delay.font.fontName, size: 15)
        self.delay.isHidden = true
        self.addSubview(self.delay)

        NSLayoutConstraint.activate([
            self.minute.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.minute.topAnchor.constraint(equalTo: self.safeArea.topAnchor, constant: 5),
            self.minute.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor, constant: -5),
            self.minute.widthAnchor.constraint(equalToConstant: 50),
            self.minute.heightAnchor.constraint(equalToConstant: 50),

            self.destination.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 10),
            self.destination.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.destination.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),

            self.platform.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.platform.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.platform.leftAnchor.constraint(greaterThanOrEqualTo: self.destination.rightAnchor, constant: 10),
            self.platform.heightAnchor.constraint(equalToConstant: 15),

            self.length.topAnchor.constraint(equalTo: self.platform.bottomAnchor, constant: 2),
            self.length.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.length.leftAnchor.constraint(greaterThanOrEqualTo: self.destination.rightAnchor, constant: 10),
            self.length.heightAnchor.constraint(equalToConstant: 15),

            self.delay.topAnchor.constraint(equalTo: self.length.bottomAnchor, constant: 2),
            self.delay.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.delay.leftAnchor.constraint(greaterThanOrEqualTo: self.destination.rightAnchor, constant: 10),
            self.delay.heightAnchor.constraint(equalToConstant: 15),
        ])
    }

    func setDeparture(departure: Departure) {
        self.departure = departure
        reloadDepartureData()
    }

    private func reloadDepartureData() {
        self.minute.text = self.departure.minutes
        self.minute.layer.backgroundColor = UIColor(self.departure.hexcolor).cgColor
        self.destination.text = self.departure.destination!
        self.length.text = self.departure.length + " cars"
        self.platform.text = "Platform " + self.departure.platform
        self.delay.text = "Delay: " + String(Int(self.departure.delay)! / 60) + " min"
        self.delay.isHidden = self.departure.delay == "0"
    }
}
