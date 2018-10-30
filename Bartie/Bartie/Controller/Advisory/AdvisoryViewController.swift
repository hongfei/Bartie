//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class AdvisoryViewController: UITableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        self.view.backgroundColor = .white
        self.title = "Advisories"
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
