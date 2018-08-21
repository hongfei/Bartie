//
// Created by Hongfei on 2018/8/20.
// Copyright (c) 2018 Hongfei Zhou.? All rights reserved.
//

import UIKit
import PinLayout
import UIColor_Hex_Swift

class DetourRoute: UITableViewCell {
    public static let HEIGHT = CGFloat(240)


    var targetTrainSymbol: UILabel = UILabel()
    var detourTrainSymbol: UILabel = UILabel()
    var exchangeSymbol: UILabel = UILabel()
    var detourTrainName: UILabel = UILabel()
    var targetTrainName: UILabel = UILabel()
    var exchangeStation: UILabel = UILabel()
    var detourMinutes: UILabel = UILabel()
    var targetTrainMinutes: UILabel = UILabel()
    var downArrow: UIImageView = UIImageView()
    var upArrow: UIImageView = UIImageView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let view = self.contentView

        self.targetTrainSymbol.layer.cornerRadius = 17.5
        view.addSubview(self.targetTrainSymbol)

        self.targetTrainName.text = "Not Available"
        self.targetTrainName.font = UIFont(name: self.targetTrainName.font.fontName, size: CGFloat(20))
        self.targetTrainName.adjustsFontSizeToFitWidth = true
        self.targetTrainName.minimumScaleFactor = 0.5
        view.addSubview(self.targetTrainName)

        self.targetTrainMinutes.text = "Not Available"
        view.addSubview(self.targetTrainMinutes)

        self.detourTrainSymbol.layer.cornerRadius = 17.5
        view.addSubview(self.detourTrainSymbol)

        self.detourTrainName.text = "Not Available"
        self.detourTrainName.font = UIFont(name: self.detourTrainName.font.fontName, size: CGFloat(20))
        self.detourTrainName.adjustsFontSizeToFitWidth = true
        self.detourTrainName.minimumScaleFactor = 0.5
        view.addSubview(self.detourTrainName)

        self.detourMinutes.text = "Not Available"
        view.addSubview(self.detourMinutes)

        self.exchangeSymbol.layer.cornerRadius = 17.5
        self.exchangeSymbol.layer.backgroundColor = UIColor.gray.cgColor
        view.addSubview(self.exchangeSymbol)

        self.exchangeStation.text = "Not Available"
        self.exchangeStation.font = UIFont(name: self.exchangeStation.font.fontName, size: CGFloat(20))
        self.exchangeStation.adjustsFontSizeToFitWidth = true
        self.exchangeStation.minimumScaleFactor = 0.5
        view.addSubview(self.exchangeStation)

        self.downArrow.image = Icons.arrowDown
        view.addSubview(self.downArrow)

        self.upArrow.image = Icons.arrowUp
        view.addSubview(self.upArrow)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let pin = self.contentView.pin
        self.detourTrainSymbol.pin.top(pin.safeArea).left(pin.safeArea).marginLeft(10).height(35).width(35)
        self.targetTrainSymbol.pin.bottom(pin.safeArea).left(pin.safeArea).marginLeft(10).height(35).width(35)
        self.exchangeSymbol.pin.height(35).width(35).left(pin.safeArea).marginLeft(10).vCenter()

        self.detourTrainName.pin.after(of: self.detourTrainSymbol, aligned: .center).height(30).right(pin.safeArea).marginLeft(20)
        self.targetTrainName.pin.after(of: self.targetTrainSymbol, aligned: .center).height(30).right(pin.safeArea).marginLeft(20)
        self.exchangeStation.pin.after(of: self.exchangeSymbol, aligned: .center).height(30).right(pin.safeArea).marginLeft(20)

        self.downArrow.pin.height(30).width(30).left(pin.safeArea).marginLeft(12.5).vCenter(-20%)
        self.upArrow.pin.height(30).width(30).left(pin.safeArea).marginLeft(12.5).vCenter(20%)

        self.detourMinutes.pin.after(of: self.downArrow, aligned: .center).marginLeft(25).height(30).right(pin.safeArea)
        self.targetTrainMinutes.pin.after(of: self.upArrow, aligned: .center).marginLeft(25).height(30).right(pin.safeArea)
    }

    func reloadCellData(detour: Departure?, target: Departure?, exchange: Station?, detourTime: Int?, targetTime: Int?) {
        guard let actualDetour = detour, let actualTarget = target, let actualExchange = exchange,
              let actualDetourTime = detourTime, let actualTargetTime = targetTime else {
            return
        }
        self.detourTrainName.text = actualDetour.destination
        self.detourTrainSymbol.layer.backgroundColor = UIColor(actualDetour.hexcolor).cgColor
        self.targetTrainName.text = actualTarget.destination
        self.targetTrainSymbol.layer.backgroundColor = UIColor(actualTarget.hexcolor).cgColor
        self.exchangeStation.text = actualExchange.name
        self.detourMinutes.text = String(actualDetourTime) + " min"
        self.targetTrainMinutes.text = String(actualTargetTime) + " min"
    }
}
