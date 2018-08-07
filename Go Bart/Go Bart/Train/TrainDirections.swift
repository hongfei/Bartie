//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainDirections: UIView {



    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(holdingViewController: TrainViewController) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.holdingViewController = holdingViewController

        placeFromLabel()
        placeFromStation()
        placeToLabel()
        placeToStation()
    }


}
