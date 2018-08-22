//
// Created by Zhou, Hongfei on 8/21/18.
// Copyright (c)? 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import PinLayout

class CurrentStation: UITableViewCell {
    public static let HEIGHT = CGFloat(45)
    var currentStationLabel: UILabel = UILabel()
    var currentStationSymbol: UIImageView = UIImageView()

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false

        let view = self.contentView
        self.currentStationSymbol.image = Icons.location
        contentView.addSubview(self.currentStationSymbol)

        self.currentStationLabel.text = "Not Available"
        self.currentStationLabel.font = UIFont(name: self.currentStationLabel.font.fontName, size: CGFloat(20))
        self.currentStationLabel.adjustsFontSizeToFitWidth = true
        self.currentStationLabel.minimumScaleFactor = 0.5
        view.addSubview(self.currentStationLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let pin = self.contentView.pin
        self.currentStationSymbol.pin.left(pin.safeArea).marginLeft(15).vCenter().height(25).width(25)
        self.currentStationLabel.pin.after(of: self.currentStationSymbol, aligned: .center).right(pin.safeArea).height(25)
    }

    func setCurrentStation(for station: Station) {
        self.currentStationLabel.text = station.name
    }

}
