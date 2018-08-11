//
// Created by Zhou, Hongfei on 8/8/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class DepartureListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var departures: [Departure] = []
    var departureListViewDelegate: DepartureListViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.register(DepartureListCell.self, forCellReuseIdentifier: "DepartureListCell")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DepartureListCell {
            self.departureListViewDelegate?.onItemSelected(departure: cell.departure)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartureListCell", for: indexPath) as! DepartureListCell
        cell.setDeparture(departure: departures[indexPath.row])

        return cell
    }
}

protocol DepartureListViewDelegate {
    func onItemSelected(departure: Departure)
}