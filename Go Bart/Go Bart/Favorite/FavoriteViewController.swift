//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftIcons


class FavoriteViewController: UIViewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Favorite"
        self.view.backgroundColor = UIColor.orange
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}