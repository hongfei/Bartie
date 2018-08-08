//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class BartTabBarController: UITabBarController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [
            ViewControllerManager.getViewController(of: TrainViewController.self),
            ViewControllerManager.getViewController(of: FavoriteViewController.self)
        ].map { vc in
            UINavigationController(rootViewController: vc)
        }
    }
}
