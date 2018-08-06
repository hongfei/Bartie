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
            TrainViewNavController(),
            FavoriteViewNavController()
        ]
    }
}
