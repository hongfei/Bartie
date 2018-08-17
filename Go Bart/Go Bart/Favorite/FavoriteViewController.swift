//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons
import UIColor_Hex_Swift
import PinLayout

class FavoriteViewController: UIViewController, FavoriteListViewDelegate {
    var safeArea: UILayoutGuide!
    var favoriteList: FavoriteListView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Favorites"
        self.view.backgroundColor = .white
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    }

    override var navigationItem: UINavigationItem {
        let navItem = UINavigationItem(title: "Favorites")
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self.favoriteList, action: #selector(FavoriteListView.editFavorites))
        navItem.rightBarButtonItem?.tintColor = .white
        return navItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.safeArea = self.view.safeAreaLayoutGuide
        self.favoriteList = FavoriteListView()
        self.favoriteList.favoriteListDelegate = self
        self.favoriteList.favorites = DataCache.getAllFavorites()
        self.favoriteList.rowHeight = UITableViewAutomaticDimension
        self.favoriteList.estimatedRowHeight = 80

        self.view.addSubview(self.favoriteList)
        self.favoriteList.pin.all()
        self.onRefreshList()
        self.favoriteList.reloadData()
    }

    func onRefreshList() {
        let favorites = DataCache.getAllFavorites()
        self.favoriteList.favorites = favorites
        var refreshCount = favorites.count

        if refreshCount == 0 {
            self.favoriteList.refreshControl?.endRefreshing()
            return
        }

        for (index, favorite) in favorites.enumerated() {
            BartScheduleService.getTripPlan(from: favorite.station, to: favorite.destination) { trips in
                self.favoriteList.tripsListMap[index] = trips
                BartRealTimeService.getSelectedDepartures(for: favorite.station) { departures in
                    self.favoriteList.departureMap[index] = departures
                    self.favoriteList.reloadData()
                    refreshCount -= 1
                    if refreshCount == 0 {
                        self.favoriteList.refreshControl?.endRefreshing()
                    }
                }
            }
        }
    }
}
