//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift
import PinLayout

class FavoriteViewController: UIViewController, FavoriteListViewDelegate {
    var favoriteList: FavoriteListView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.view.backgroundColor = .white
    }

    override var navigationItem: UINavigationItem {
        let navItem = UINavigationItem(title: "Favorites")
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self.favoriteList, action: #selector(FavoriteListView.editFavorites))
        navItem.rightBarButtonItem?.tintColor = .white
        return navItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.favoriteList = FavoriteListView()
        self.favoriteList.favoriteListDelegate = self
        self.favoriteList.favorites = FavoriteService.getAllFavorites()

        self.view.addSubview(self.favoriteList)
        self.onRefreshList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.favoriteList.pin.all()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if FavoriteService.getAllFavorites().count > self.favoriteList.favorites.count {
            self.onRefreshList()
        }
    }

    func onRefreshList() {
        let favorites = FavoriteService.getAllFavorites()
        self.favoriteList.favorites = favorites
        var refreshCount = favorites.count

        if refreshCount == 0 {
            self.favoriteList.refreshControl?.endRefreshing()
            return
        }

        for (index, favorite) in favorites.enumerated() {
            ScheduleService.getTripPlan(from: favorite.station, to: favorite.destination, beforeCount: 1, afterCount: 2) { trips in
                RealTimeService.getSelectedDepartures(for: favorite.station) { departures in
                    self.favoriteList.tripsListMap[index] = DataUtil.regulateTripsWithDepartures(for: trips, with: departures)
                    refreshCount -= 1
                    if refreshCount == 0 {
                        self.favoriteList.reloadData()
                        self.favoriteList.refreshControl?.endRefreshing()
                    }
                }
            }
        }
    }

    func onSelectRow(for trip: Trip, with departure: Departure?, from favorite: Favorite) {
        let favoriteDetail = FavoriteDetailViewController()
        favoriteDetail.trip = trip
        favoriteDetail.departure = departure
        favoriteDetail.favorite = favorite

        self.present(FavoriteDetailNavigationViewController(rootViewController: favoriteDetail), animated: true)
    }
}
