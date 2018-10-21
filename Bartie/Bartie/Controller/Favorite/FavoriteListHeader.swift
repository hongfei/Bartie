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
    var stationLabel: UILabel = UILabel()
    var destinationLabel: UILabel = UILabel()
    var deleteButton: UIButton = UIButton()
    var directionImage: UIImageView = UIImageView()
    var isDeleting: Bool = false

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 0, 0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.stationLabel.minimumScaleFactor = 0.85
        self.stationLabel.adjustsFontSizeToFitWidth = true
        self.stationLabel.textAlignment = .center
        self.addSubview(self.stationLabel)

        self.destinationLabel.minimumScaleFactor = 0.85
        self.destinationLabel.adjustsFontSizeToFitWidth = true
        self.destinationLabel.textAlignment = .center
        self.addSubview(self.destinationLabel)

        self.directionImage.image = Icons.rightArrow
        self.addSubview(self.directionImage)

        self.deleteButton.setImage(Icons.delete, for: .normal)
        self.deleteButton.addTarget(self, action: #selector(deleteFavorite), for: .touchUpInside)
        self.addSubview(self.deleteButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        pin.height(44)
        self.deleteButton.pin.right(pin.safeArea).vCenter().height(30).width(30)
        self.stationLabel.pin.left(pin.safeArea).vCenter().minWidth(30%).maxWidth(50%).sizeToFit(.widthFlexible)
        self.directionImage.pin.after(of: self.stationLabel).vCenter().height(20).width(20)
        self.destinationLabel.pin.after(of: directionImage).before(of: self.deleteButton).vCenter().minWidth(30%).sizeToFit(.widthFlexible)
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
