//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class StationTableCell: UITableViewCell {
    var station: Station!
    var safeArea: UILayoutGuide!
    var name: UILabel!
    var county: UILabel!
    var address: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(5, 20, 5, 20)
    }

    func initializeCell() {
        self.backgroundColor = UIColor.white
        self.safeArea = self.safeAreaLayoutGuide

        name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: name.font.fontName, size: 17)
        self.addSubview(name)

        county = UILabel()
        county.translatesAutoresizingMaskIntoConstraints = false
        county.font = UIFont(name: county.font.fontName, size: 10)
        county.textAlignment = .right
        self.addSubview(county)

        address = UILabel()
        address.translatesAutoresizingMaskIntoConstraints = false
        address.font = UIFont(name: county.font.fontName, size: 10)
        self.addSubview(address)

        NSLayoutConstraint.activate([
            self.name.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.name.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.name.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.name.heightAnchor.constraint(equalToConstant: 30),
            self.address.topAnchor.constraint(equalTo: self.name.bottomAnchor),
            self.address.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.address.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor),
            self.address.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            self.county.topAnchor.constraint(equalTo: self.name.bottomAnchor),
            self.county.widthAnchor.constraint(equalToConstant: 80),
            self.county.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.county.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor)
        ])
    }

    func setStation(station: Station) {
        self.station = station
        reloadStationData()
    }
    
    private func reloadStationData() {
        self.name.text = self.station.name
        self.address.text = self.station.address
        self.county.text = self.station.county
    }
}
