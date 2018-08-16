//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TripListView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var tripListDelegate: TripListViewDelegate?
    var trips: [Trip] = []
    var station: Station!
    var destination: Station!
    var routeMap: [String: Route]!

    var departures: [Departure]!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView(frame: CGRect.zero)
        self.register(TripListCell.self, forCellReuseIdentifier: "TripListCell")
        self.register(AddToFavoriteCell.self, forCellReuseIdentifier: "AddToFavoriteCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TripListCell {
            self.tripListDelegate?.onTripSelected(trip: cell.trip, from: cell.station, to: cell.destination, with: cell.departure)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.trips.count
        case 1: return 1
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripListCell", for: indexPath) as! TripListCell
            cell.trip = trips[indexPath.row]
            cell.station = self.station
            cell.destination = self.destination
            cell.departure = DataUtil.findClosestDeparture(in: departures, for: cell.trip)
            cell.reloadTripData()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddToFavoriteCell") as! AddToFavoriteCell
            return cell
        default:
            return UITableViewCell()
        }

    }
}

protocol TripListViewDelegate {
    func onTripSelected(trip: Trip, from station: Station, to destination: Station, with departure: Departure?)
}