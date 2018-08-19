//
// Created by Zhou, Hongfei on 8/8/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class DepartureListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var departures: [Departure] = []
    var departureListDelegate: DepartureListViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView(frame: CGRect.zero)
        self.register(DepartureListCell.self, forCellReuseIdentifier: "DepartureListCell")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DepartureListCell {
            self.departureListDelegate?.onDepartureSelected(departure: cell.departure)
            cell.setSelected(false, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartureListCell", for: indexPath)
        if let departureCell = cell as? DepartureListCell {
            departureCell.setDeparture(departure: departures[indexPath.row])
            return departureCell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DepartureListCell.HEIGHT
    }
}

protocol DepartureListViewDelegate {
    func onDepartureSelected(departure: Departure)
}
