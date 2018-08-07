//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainViewNavController: UINavigationController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    init() {
        super.init(rootViewController: TrainViewController())
    }
}

class TrainViewController: UIViewController, StationTapDelegate {
    var safeArea: UILayoutGuide!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Trains"
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        self.tabBarItem.title = "Trains"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.safeArea = self.view.safeAreaLayoutGuide
        self.view.backgroundColor = UIColor.white

        let trainDirections = TrainDirections()
        trainDirections.stationTapDelegate = self
        let constraints = [
            trainDirections.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor),
            trainDirections.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor),
            trainDirections.topAnchor.constraint(equalTo: self.safeArea.topAnchor),
            trainDirections.heightAnchor.constraint(equalToConstant: 40)
        ]

        self.view.addSubview(trainDirections)
        NSLayoutConstraint.activate(constraints)
    }

    func openStationPicker(on sender: UIView) {
        let target = UINavigationController(rootViewController: StationPickerViewController())
        self.present(target, animated: true)
    }
}
