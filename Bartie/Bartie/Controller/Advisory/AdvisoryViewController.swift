//
// Created by Zhou, Hongfei on 10/30/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import PinLayout

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


        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(AdvisoryCell.self, forCellReuseIdentifier: "AdvisoryCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let advisoryCell = tableView.dequeueReusableCell(withIdentifier: "AdvisoryCell", for: indexPath) as? AdvisoryCell {
//            advisoryCell.loadViewData(advisory: advisory)
            return advisoryCell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = AdvisoryCell()
        cell.layoutSubviews()
        return cell.contentView.frame.height
    }
}
