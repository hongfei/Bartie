//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TripListView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var tripListDelegate: TripListViewDelegate?
    var trips: [Trip] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.register(TripListCell.self, forCellReuseIdentifier: "TripListCell")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TripListCell {
            self.tripListDelegate?.onTripSelected(trip: cell.trip)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListCell", for: indexPath) as! TripListCell
        cell.setTrip(trip: trips[indexPath.row])

        return cell
    }
}

protocol TripListViewDelegate {
    func onTripSelected(trip: Trip)
}