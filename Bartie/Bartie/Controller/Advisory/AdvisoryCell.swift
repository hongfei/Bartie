//
// Created by Zhou, Hongfei on 11/2/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import PinLayout

class AdvisoryCell: UITableViewCell {
    let station: UILabel = UILabel()
    let advisoryDescription: UILabel = UILabel()
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.station.font = UIFont.boldSystemFont(ofSize: 20)
        self.contentView.addSubview(self.station)

        self.advisoryDescription.textColor = .darkGray
        self.advisoryDescription.lineBreakMode = .byWordWrapping
        self.advisoryDescription.numberOfLines = 0
        self.contentView.addSubview(self.advisoryDescription)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let pin = self.contentView.pin

        self.station.pin.top(pin.safeArea).horizontally(pin.safeArea).height(30)
        self.advisoryDescription.pin.below(of: self.station).horizontally(pin.safeArea).bottom(pin.safeArea).sizeToFit(.width)
    }

    func loadViewData(advisory: Advisory) {
        self.station.text = advisory.type
        self.advisoryDescription.text = advisory.description.cdData
        self.advisoryDescription.sizeToFit()
    }
}
