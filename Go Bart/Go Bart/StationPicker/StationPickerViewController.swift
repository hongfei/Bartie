//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit


class StationPickerViewController: UIViewController {
    var safeArea: UILayoutGuide!
    var barTitle: String!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(barTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.barTitle = barTitle
    }

    override var navigationItem: UINavigationItem {
        let navigationItem = UINavigationItem(title: barTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeStationPicker))
        return navigationItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple

        BartStationService.getAllStations() { stations in
            self.addChildViewController(StationCollectionViewController(stations: stations))
        }
    }

    @objc func closeStationPicker() {
        self.dismiss(animated: true)
    }
}
