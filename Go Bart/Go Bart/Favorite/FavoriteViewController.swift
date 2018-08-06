//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FavoriteViewNavController: UINavigationController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    init() {
        super.init(rootViewController: FavoriteViewController())
        self.navigationBar.barTintColor = UIColor.brown
    }
}

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