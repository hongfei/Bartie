//
// Created by Hongfei on 2018/8/15.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FavoriteListView: UITableView, UITableViewDataSource, UITableViewDelegate, FavoriteListHeaderDelegate {

    var favorites: [Favorite] = []
    var departureMap: [Int: [Departure]] = [:]
    var tripsListMap: [Int: [Trip]] = [:]
    var favoriteListDelegate: FavoriteListViewDelegate?
    var inDeleteFavoriteMode: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(FavoriteListCell.self, forCellReuseIdentifier: "FavoriteListCell")
        self.register(FavoriteListHeader.self, forHeaderFooterViewReuseIdentifier: "FavoriteListHeader")

        self.allowsSelection = false
        self.tableFooterView = UIView(frame: CGRect.zero)

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(onTableRefresh), for: .valueChanged)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.favorites.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.favoriteTripCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteListCell", for: indexPath)
        if let favoriteCell = cell as? FavoriteListCell {
            guard let tripList = self.tripsListMap[indexPath.section] else {
                return favoriteCell
            }
            let trip = tripList[indexPath.row]
            guard let departures = self.departureMap[indexPath.section], let departure = DataUtil.findClosestDeparture(in: departures, for: trip) else {
                return favoriteCell
            }
            favoriteCell.reloadData(with: departure, of: trip, for: favorites[indexPath.section])
            return favoriteCell
        } else {
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavoriteListCell.HEIGHT
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

    @IBAction func onTableRefresh() {
        self.favoriteListDelegate?.onRefreshList()
    }

    @IBAction func editFavorites(_ sender: UIBarButtonItem) {
        self.inDeleteFavoriteMode = !self.inDeleteFavoriteMode
        if self.inDeleteFavoriteMode {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
        self.reloadData()
    }

    func onDeleteFavorite(favorite: Favorite) {
        DataCache.deleteFavorite(favorite: favorite)
        self.favorites = DataCache.getAllFavorites()
        self.reloadData()
    }
}

protocol FavoriteListViewDelegate {
    func onRefreshList()
}