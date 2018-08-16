//
// Created by Zhou, Hongfei on 8/15/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//
import UIKit

class AddToFavoriteCell: UITableViewCell {
    var addButton: UIButton!
    var safeArea: UILayoutGuide!

    var station: Station?
    var destination: Station?
    var trips: [Trip] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 15)
    }

    func initializeCell() {
        self.safeArea = self.contentView.safeAreaLayoutGuide
        self.selectionStyle = .none
        self.addButton = UIButton(type: .system)
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.setTitle("Add to Favorite", for: .normal)
        self.addButton.setTitle("Already added to favorite", for: .disabled)
        self.addButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        self.contentView.addSubview(self.addButton)

        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.safeArea.topAnchor, constant: 10),
            self.addButton.bottomAnchor.constraint(equalTo: self.safeArea.bottomAnchor, constant: -10),
            self.addButton.heightAnchor.constraint(equalToConstant: 20),
            self.addButton.centerXAnchor.constraint(equalTo: self.safeArea.centerXAnchor)
        ])
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
