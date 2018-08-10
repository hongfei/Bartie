//
// Created by Zhou, Hongfei on 8/10/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons

class FromStationSearchBar: UIView {

    var searchBox: UITextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor("#F0F0F0")

        placeInputBox()
    }

    private func placeInputBox() {
        self.searchBox = SearchBoxField().withPlaceholder(placeholder: "Station")
        self.addSubview(self.searchBox)

        NSLayoutConstraint.activate([
            self.searchBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.searchBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.searchBox.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.searchBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }

    func reloadStation(station: Station) {
        self.searchBox.text = station.name
        self.searchBox.leftViewMode = .never
    }
}

class ToStationSearchBar: UIView {

    var searchBox: UITextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor("#F0F0F0")

        placeInputBox()
    }

    private func placeInputBox() {
        self.searchBox = SearchBoxField().withPlaceholder(placeholder: "Destination")
        self.searchBox.rightViewMode = .never
        self.addSubview(self.searchBox)

        NSLayoutConstraint.activate([
            self.searchBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.searchBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.searchBox.topAnchor.constraint(equalTo: self.topAnchor),
            self.searchBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }

    func reloadStation(station: Station) {
        self.searchBox.text = station.name
        self.searchBox.leftViewMode = .never
    }
}

class SearchBoxField: UITextField {
    let searchIcon = UIImage(icon: .icofont(.search), size: CGSize(width: 20, height: 20), textColor: UIColor("#C7C7CD"), backgroundColor: .white)
    let locatingIcon = UIImage(icon: .icofont(.locationArrow), size: CGSize(width: 20, height: 20), textColor: UIColor("#C7C7CD"), backgroundColor: .white)

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.center.x - 50, y: 0, width: 100, height: bounds.height)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.center.x - 65, y: (bounds.height - searchIcon.size.height) / 2, width: searchIcon.size.width, height: searchIcon.size.height)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.maxX - 30, y: (bounds.height - searchIcon.size.height) / 2, width: locatingIcon.size.width, height: locatingIcon.size.height)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.borderColor = UIColor("#E0E0E0").cgColor
        self.layer.cornerRadius = 8

        self.textAlignment = .center
        self.leftViewMode = .always
        self.leftView = UIImageView(image: searchIcon)
        self.rightViewMode = .always
        self.rightView = UIImageView(image: locatingIcon)

        self.isEnabled = false
    }

    func withPlaceholder(placeholder: String) -> SearchBoxField {
        self.placeholder = placeholder
        return self
    }
}