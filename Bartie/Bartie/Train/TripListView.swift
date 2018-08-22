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
            cell.setSelected(false, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.trips.count
        case 1: return self.trips.count > 0 ? 1 : 0
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TripListCell") as? TripListCell {
                cell.trip = self.trips[indexPath.row]
                cell.station = self.station
                cell.destination = self.destination
                cell.departure = DataUtil.findClosestDeparture(in: self.departures, for: cell.trip)
                cell.reloadTripData()
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddToFavoriteCell") as? AddToFavoriteCell {
                cell.station = self.station
                cell.destination = self.destination
                cell.trips = self.trips
                cell.refreshButton()
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let height = CGFloat(self.trips[indexPath.row].leg.count * 20 + 70)
            return height
        case 1:
            return AddToFavoriteCell.HEIGHT
        default:
            return 0
        }
    }

    func reloadTripList(trips: [Trip], with departures: [Departure], from station: Station, to destination: Station) {
        self.station = station
        self.destination = destination
        self.departures = departures
        self.trips = trips

        self.reloadData()
    }
}

protocol TripListViewDelegate {
    func onTripSelected(trip: Trip, from station: Station, to destination: Station, with departure: Departure?)
}
