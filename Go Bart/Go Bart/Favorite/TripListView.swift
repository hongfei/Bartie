//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TripListView: UITableView {
    var tripListDelegate: TripListDelegate!
    var tripListDataSource: TripListDataSource!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(TripListCell.self, forCellReuseIdentifier: "TripListCell")
    }

    func setDelegate(delegate: TripListDelegate) {
        self.tripListDelegate = delegate
        self.delegate = delegate

    }

    func setDataSource(dataSource: TripListDataSource) {
        self.tripListDataSource = dataSource
        self.dataSource = dataSource
        self.reloadData()
    }
}
