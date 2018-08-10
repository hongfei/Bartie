//
//  DepartureListCell.swift
//  Go Bart
//
//  Created by Hongfei on 2018/8/8.
//  Copyright © 2018年 Hongfei Zhou. All rights reserved.
//

import UIKit

class DepartureListCell: UITableViewCell {
    var departure: Departure!
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
        self.backgroundColor = UIColor.yellow
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
    
    func setDeparture(departure: Departure) {
        self.departure = departure
        reloadDepartureData()
    }
    
    private func reloadDepartureData() {
        self.name.text = self.departure.destination! + "    " + self.departure.minutes
    }
}
