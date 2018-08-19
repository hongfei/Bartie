//
// Created by Zhou, Hongfei on 8/15/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//
import UIKit
import PinLayout

class AddToFavoriteCell: UITableViewCell {
    public static let HEIGHT = CGFloat(44)
    var addButton: UIButton = UIButton(type: .system)

    var station: Station?
    var destination: Station?
    var trips: [Trip] = []

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(15, 10, 15, 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addButton.setTitle("Add to Favorite", for: .normal)
        self.addButton.setTitle("Already added to favorite", for: .disabled)
        self.addButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        self.addSubview(self.addButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addButton.pin.center().height(20).width(80%)
    }

    func refreshButton() {
        guard let station = self.station, let destination = self.destination else {
            return
        }
        if let _ = DataCache.getFavorite(from: station, to: destination) {
            self.addButton.isEnabled = false
        } else {
            self.addButton.isEnabled = !trips.isEmpty
        }
    }

    @IBAction func addFavorite() {
        guard let station = self.station, let destination = self.destination else {
            return
        }
        DataCache.saveFavorite(from: station, to: destination)
        refreshButton()
    }
}
