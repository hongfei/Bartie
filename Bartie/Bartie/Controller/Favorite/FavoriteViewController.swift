//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift
import PinLayout

class FavoriteViewController: UITableViewController, FavoriteListHeaderDelegate {
    var favorites: [Favorite] = []
    var tripsListMap: [Int: [(Trip, Departure?)]] = [:]
    var inDeleteFavoriteMode: Bool = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.view.backgroundColor = .white
        self.title = "Favorites"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editFavorites))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.view.backgroundColor = .white

        self.tableView.register(TripListCell.self, forCellReuseIdentifier: "TripListCell")
        self.tableView.register(FavoriteListHeader.self, forHeaderFooterViewReuseIdentifier: "FavoriteListHeader")
        self.tableView.tableFooterView = UIView(frame: .zero)

        self.favorites = FavoriteService.getAllFavorites()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.favorites.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tripList = self.tripsListMap[section] {
            return min(Settings.favoriteTripCount, tripList.count)
        }
        return Settings.favoriteTripCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListCell", for: indexPath)
        guard let favoriteCell = cell as? TripListCell, let tripList = self.tripsListMap[indexPath.section] else {
            return cell
        }

        favoriteCell.trip = tripList[indexPath.row].0
        favoriteCell.departure = tripList[indexPath.row].1
        favoriteCell.station = self.favorites[indexPath.section].station
        favoriteCell.destination = self.favorites[indexPath.section].destination
        favoriteCell.reloadTripData()
        return favoriteCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let trips = self.tripsListMap[indexPath.section] else {
            return 0
        }

        return CGFloat(trips[indexPath.row].0.leg.count * 20 + 70)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FavoriteListHeader.HEIGHT
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cellHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FavoriteListHeader") as? FavoriteListHeader else {
            return nil
        }

        let favorite = self.favorites[section]
        cellHeader.favoriteListHeaderDelegate = self
        cellHeader.setData(favorite: favorite, isDeleting: self.inDeleteFavoriteMode)
        return cellHeader
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if FavoriteService.getAllFavorites().count > self.favorites.count {
            self.refreshTable()
        }
    }

    @IBAction func refreshTable() {
        self.favorites = FavoriteService.getAllFavorites()

        if self.favorites.count == 0 {
            self.refreshControl?.endRefreshing()
        }

        var refreshCount = self.favorites.count
        for (index, favorite) in self.favorites.enumerated() {
            ScheduleService.getTripsWithDeparture(from: favorite.station, to: favorite.destination) { tripsWithDeparture in
                self.tripsListMap[index] = tripsWithDeparture
                refreshCount -= 1
                if refreshCount == 0 {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let favoriteCell = cell as? TripListCell {
            let favoriteDetail = FavoriteDetailViewController()
            favoriteDetail.trip = favoriteCell.trip
            favoriteDetail.departure = favoriteCell.departure
            favoriteDetail.favorite = self.favorites[indexPath.section]
            self.present(FavoriteDetailNavigationViewController(rootViewController: favoriteDetail), animated: true)

            favoriteCell.setSelected(false, animated: true)
        }
    }

    @IBAction func editFavorites(_ sender: UIBarButtonItem) {
        self.inDeleteFavoriteMode = !self.inDeleteFavoriteMode
        sender.title = self.inDeleteFavoriteMode ? "Done" : "Edit"
        self.tableView.reloadData()
    }

    func onDeleteFavorite(favorite: Favorite) {
        FavoriteService.deleteFavorite(favorite: favorite)
        self.favorites = FavoriteService.getAllFavorites()
        self.tableView.reloadData()
    }
}