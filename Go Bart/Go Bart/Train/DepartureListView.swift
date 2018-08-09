//
// Created by Zhou, Hongfei on 8/8/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class DepartureListView: UITableView {
    var departureDelegate: DepartureListDelegate!
    var departureDataSource: DepartureListDataSource!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(DepartureListCell.self, forCellReuseIdentifier: "DepartureListCell")
    }

    func setDelegate(delegate: DepartureListDelegate) {
        self.departureDelegate = delegate
        self.delegate = delegate

    }

    func setDataSource(dataSource: DepartureListDataSource) {
        self.departureDataSource = dataSource
        self.dataSource = dataSource
        self.reloadData()
    }
}
