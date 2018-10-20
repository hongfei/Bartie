//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class RoundCornerNavigationBar: UINavigationBar {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner ]
        self.clipsToBounds = true
    }
}
