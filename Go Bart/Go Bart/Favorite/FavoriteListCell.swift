//
// Created by Hongfei on 2018/8/15.
// C?opyright (c) 2018 Hongfei Zh?ou.? A?ll rights reserved.
//

import UIKit
import PinLayout
import UIColor_Hex_Swift

class FavoriteListCell: UITableViewCell {
    var minuteLabel: UILabel!
    var trainLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.autoresizingMask = .flexibleHeight

        self.minuteLabel = UILabel()
        self.minuteLabel.layer.cornerRadius = 25
        self.minuteLabel.textAlignment = .center
        self.addSubview(self.minuteLabel)

        self.trainLabel = UILabel()
        self.addSubview(self.trainLabel)

        self.minuteLabel.pin.left(pin.safeArea).height(50).width(50).vCenter()
        self.trainLabel.pin.after(of: self.minuteLabel, aligned: .center).marginLeft(10).height(30).right(pin.safeArea)
    }

    func reloadData(with departure: Departure, of trip: Trip, for favorite: Favorite) {
        self.minuteLabel.text = departure.minutes
        self.minuteLabel.backgroundColor = UIColor(departure.hexcolor)
        self.trainLabel.text = departure.destination
    }
}
