//
// Created by Hongfei on 11/8/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import PinLayout

class WideHeadCell: UITableViewHeaderFooterView {
    public static let HEIGHT = CGFloat(44)

    var headerNameLabel: UILabel = UILabel()

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.headerNameLabel.minimumScaleFactor = 0.85
        self.headerNameLabel.adjustsFontSizeToFitWidth = true
        self.headerNameLabel.font = FontUtil.pingFangTCRegular(size: 17)
        self.addSubview(self.headerNameLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        pin.height(44)
        self.headerNameLabel.pin.all(pin.safeArea)
    }

    func loadViewData(text: String?) {
        self.headerNameLabel.text = text
    }
}
