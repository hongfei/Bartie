//
//  DepartureListCell.swift
//  Go Bart
//
//  Created by Hongfei on 2018/8/8.
//  Copyright © 2018年 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class DepartureListCell: UITableViewCell {
    var departure: Departure!

    var destination: UILabel!
    var minute: UILabel!
    var platform: UILabel!
    var length: UILabel!
    var bikeflag: UILabel!
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
        self.minute.layer.cornerRadius = 20
        self.addSubview(self.minute)

        self.destination = UILabel()
        self.destination.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.destination)

        NSLayoutConstraint.activate([
            self.minute.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.minute.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.minute.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.minute.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            self.minute.widthAnchor.constraint(equalToConstant: 40),
            self.minute.heightAnchor.constraint(equalToConstant: 40),
            self.destination.leadingAnchor.constraint(equalTo: self.minute.trailingAnchor, constant: 10),
            self.destination.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.destination.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.destination.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor)
        ])
    }
    
    func setDeparture(departure: Departure) {
        self.departure = departure
        reloadDepartureData()
    }
    
    private func reloadDepartureData() {
        self.minute.text = self.departure.minutes
        self.minute.backgroundColor = UIColor(self.departure.hexcolor)
        self.destination.text = self.departure.destination!
    }
}
