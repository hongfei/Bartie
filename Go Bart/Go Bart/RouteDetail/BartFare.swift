//
// Created by Hongfei on 2018/8/19.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.?
//

import UIKit
import PinLayout

class BartFare: UITableViewCell {
    public static let HEIGHT = CGFloat(130)
    var clipper: UILabel = UILabel()
    var clipperAmount: UILabel = UILabel()
    var cash: UILabel = UILabel()
    var cashAmount: UILabel = UILabel()
    var senior: UILabel = UILabel()
    var seniorAmount: UILabel = UILabel()
    var youth: UILabel = UILabel()
    var youthAmount: UILabel = UILabel()
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(5, 30, 5, 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = false

        self.addSubview(self.clipper)
        self.addSubview(self.clipperAmount)
        self.addSubview(self.cash)
        self.addSubview(self.cashAmount)
        self.addSubview(self.senior)
        self.addSubview(self.seniorAmount)
        self.addSubview(self.youth)
        self.addSubview(self.youthAmount)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.clipperAmount.pin.top(pin.safeArea).right(pin.safeArea).width(80).height(30)
        self.clipper.pin.top(pin.safeArea).left(pin.safeArea).before(of: self.clipperAmount).height(30)
        self.cashAmount.pin.below(of: self.clipperAmount, aligned: .right).height(of: self.clipper).width(of: self.clipperAmount)
        self.cash.pin.below(of: self.clipper, aligned: .left).before(of: self.cashAmount).height(of: self.clipper)
        self.seniorAmount.pin.below(of: self.cashAmount, aligned: .right).height(of: self.clipper).width(of: self.clipperAmount)
        self.senior.pin.below(of: self.cash, aligned: .left).before(of: self.seniorAmount).height(of: self.clipper)
        self.youthAmount.pin.below(of: self.seniorAmount, aligned: .right).height(of: self.clipper).width(of: self.clipperAmount)
        self.youth.pin.below(of: self.senior, aligned: .left).before(of: self.youthAmount).height(of: self.clipper)
    }

    func reloadData(trip: Trip?) {
        guard let fares = trip?.fares.fare else { return }
        var fareMap: [String: Fare] = [:]
        for fare in fares {
            fareMap[fare.fareClass] = fare
        }
        self.clipper.text = fareMap["clipper"]?.name
        self.clipperAmount.text = fareMap["clipper"]?.amount
        self.cash.text = fareMap["cash"]?.name
        self.cashAmount.text = fareMap["cash"]?.amount
        self.senior.text = fareMap["rtcclipper"]?.name
        self.seniorAmount.text = fareMap["rtcclipper"]?.amount
        self.youth.text = fareMap["student"]?.name
        self.youthAmount.text = fareMap["student"]?.amount
    }
}
