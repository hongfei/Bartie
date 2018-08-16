//
// Created by Hongfei on 2018/8/15.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FavoriteListView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var favorites: [Favorite] = []
    var departureMap: [Int: [Departure]] = [:]
    var tripsListMap: [Int: [Trip]] = [:]
    var favoriteListDelegate: FavoriteListViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(FavoriteListCell.self, forCellReuseIdentifier: "FavoriteListCell")

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(onTableRefresh), for: .valueChanged)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.favorites.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let favorite = self.favorites[section]
        return favorite.station.name + " -> " + favorite.destination.name
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
            favoriteCell.reloadData(with: departure, of: trip, for: favorites[indexPath.row])
            return favoriteCell
        } else {
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    @IBAction func onTableRefresh() {
        self.favoriteListDelegate?.onRefreshList()

    }
}

protocol FavoriteListViewDelegate {
    func onRefreshList()
}