//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class StationTableCell: UITableViewCell {
    var station: Station!
    var name: UILabel!
    var safeArea: UILayoutGuide!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }

    func initializeCell() {
        self.backgroundColor = UIColor.gray
        self.safeArea = self.safeAreaLayoutGuide

        name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(name)

        NSLayoutConstraint.activate([
            self.name.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            self.name.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            self.name.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            self.name.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor)
        ])
    }

    func setStation(station: Station) {
        self.station = station
        reloadStationData()
    }
    
    private func reloadStationData() {
        self.name.text = self.station.name
    }
}
