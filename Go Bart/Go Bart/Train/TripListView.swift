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

    var tripCells: [TripListCell] = []

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
//            self.tripListDelegate?.onTripSelected(trip: cell.trip, from: cell.station, to: cell.destination, with: cell.departure)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.tripCells.count
        case 1: return 1
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.tripCells[indexPath.row]
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddToFavoriteCell") as! AddToFavoriteCell
            cell.station = self.station
            cell.destination = self.destination
            cell.trips = self.trips
            cell.refreshButton()
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.tripCells.count {
            print("size before return ")
            print(self.tripCells[indexPath.row].frame)
            return self.tripCells[indexPath.row].frame.height
        } else {
            return 0
        }
    }

    func reloadTripList(trips: [Trip], with departures: [Departure], from station: Station, to destination: Station) {
        self.station = station
        self.destination = destination
        self.trips = trips
        self.departures = departures
        self.tripCells = []

        for trip in trips {
            let cell = TripListCell()
            cell.station = station
            cell.destination = destination
            cell.trip = trip
            cell.departure = DataUtil.findClosestDeparture(in: departures, for: trip)
            cell.reloadTripData()
            self.tripCells.append(cell)
        }
        self.reloadData()
    }
}

protocol TripListViewDelegate {
    func onTripSelected(trip: Trip, from station: Station, to destination: Station, with departure: Departure?)
}