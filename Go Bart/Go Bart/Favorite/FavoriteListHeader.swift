//
// Created by Hongfei on 2018/8/16.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import PinLayout

class FavoriteListHeader: UITableViewHeaderFooterView {
    public static let HEIGHT = CGFloat(44)

    var favoriteListHeaderDelegate: FavoriteListHeaderDelegate?
    var favorite: Favorite!
    var stationLabel: UILabel!
    var destinationLabel: UILabel!
    var deleteButton: UIButton!
    var directionImage: UIImageView!
    var isDeleting: Bool = false

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 0, 0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.stationLabel = UILabel()
        self.stationLabel.minimumScaleFactor = 0.85
        self.stationLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.stationLabel)

        self.destinationLabel = UILabel()
        self.destinationLabel.minimumScaleFactor = 0.85
        self.destinationLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.destinationLabel)

        self.directionImage = UIImageView()
        self.directionImage.image = Icons.rightArrow
        self.addSubview(self.directionImage)

        self.deleteButton = UIButton()
        self.deleteButton.setImage(Icons.delete, for: .normal)
        self.deleteButton.addTarget(self, action: #selector(deleteFavorite), for: .touchUpInside)
        self.addSubview(self.deleteButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        pin.height(44)
        self.stationLabel.pin.left(pin.safeArea).vertically(pin.safeArea).width(40%)
        self.directionImage.pin.after(of: self.stationLabel, aligned: .center).height(20).width(20)
        self.destinationLabel.pin.after(of: directionImage, aligned: .center).height(of: self.stationLabel).width(40%)
        self.deleteButton.pin.after(of: destinationLabel, aligned: .center).right(pin.safeArea).height(30).width(30)
    }

    func setData(favorite: Favorite, isDeleting: Bool) {
        self.favorite = favorite
        self.stationLabel.text = favorite.station.name
        self.destinationLabel.text = favorite.destination.name
        self.isDeleting = isDeleting
        self.deleteButton.isHidden = !isDeleting
    }

    @IBAction func deleteFavorite() {
        self.favoriteListHeaderDelegate?.onDeleteFavorite(favorite: self.favorite)
    }
}

protocol FavoriteListHeaderDelegate {
    func onDeleteFavorite(favorite: Favorite)
}
