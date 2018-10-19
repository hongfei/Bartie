//
// Created by Hongfei on 2018/8/15.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FavoriteListView: UITableView, UITableViewDataSource, UITableViewDelegate, FavoriteListHeaderDelegate {

    var favorites: [Favorite] = []
    var tripsListMap: [Int: [(Trip, Departure?)]] = [:]
    var favoriteListDelegate: FavoriteListViewDelegate?
    var inDeleteFavoriteMode: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(TripListCell.self, forCellReuseIdentifier: "TripListCell")
        self.register(FavoriteListHeader.self, forHeaderFooterViewReuseIdentifier: "FavoriteListHeader")

        self.tableFooterView = UIView(frame: CGRect.zero)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(onTableRefresh), for: .valueChanged)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.favorites.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tripList = self.tripsListMap[section] {
            return min(Settings.favoriteTripCount, tripList.count)
        }
        return Settings.favoriteTripCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListCell", for: indexPath)
        if let favoriteCell = cell as? TripListCell {
            guard let tripList = self.tripsListMap[indexPath.section] else {
                return favoriteCell
            }
            let trip = tripList[indexPath.row].0
            favoriteCell.departure = tripList[indexPath.row].1
            favoriteCell.trip = trip
            favoriteCell.station = favorites[indexPath.section].station
            favoriteCell.destination = favorites[indexPath.section].destination
            favoriteCell.reloadTripData()
            return favoriteCell
        } else {
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let trips = self.tripsListMap[indexPath.section] {
            let height = CGFloat(trips[indexPath.row].0.leg.count * 20 + 70)
            return height
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FavoriteListHeader.HEIGHT
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FavoriteListHeader")
        if let header = cellHeader as? FavoriteListHeader {
            let favorite = self.favorites[section]
            header.favoriteListHeaderDelegate = self
            header.setData(favorite: favorite, isDeleting: self.inDeleteFavoriteMode)
            return header
        }
        return cellHeader
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let favoriteCell = cell as? TripListCell {
            self.favoriteListDelegate?.onSelectRow(for: favoriteCell.trip, with: favoriteCell.departure, from: favorites[indexPath.section])
            favoriteCell.setSelected(false, animated: true)
        }
    }

    @IBAction func onTableRefresh() {
        self.favoriteListDelegate?.onRefreshList()
    }

    @IBAction func editFavorites(_ sender: UIBarButtonItem) {
        self.inDeleteFavoriteMode = !self.inDeleteFavoriteMode
        sender.title = self.inDeleteFavoriteMode ? "Done" : "Edit"
        self.reloadData()
    }

    func onDeleteFavorite(favorite: Favorite) {
        FavoriteService.deleteFavorite(favorite: favorite)
        self.favorites = FavoriteService.getAllFavorites()
        self.reloadData()
    }
}

protocol FavoriteListViewDelegate {
    func onRefreshList()

    func onSelectRow(for trip: Trip, with departure: Departure?, from favorite: Favorite);
}
