//
// Created by Zhou, Hongfei on 8/10/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons

class StationSearchBar: UIView, UITextFieldDelegate {
    let searchIcon = UIImage(icon: .icofont(.search), size: CGSize(width: 20, height: 20), textColor: UIColor("#C7C7CD"), backgroundColor: .white)
    let locatingIcon = UIImage(icon: .icofont(.locationArrow), size: CGSize(width: 20, height: 20), textColor: UIColor("#C7C7CD"), backgroundColor: .white)

    var fromSearchBox = SearchBoxField().withPlaceholder(placeholder: "Station")
    var toSearchBox = SearchBoxField().withPlaceholder(placeholder: "Destination")
    var delegate: StationSearchBarDelegate? {
        didSet {
            self.fromSearchBox.addTarget(delegate, action: #selector(StationSearchBarDelegate.onTapFromBox), for: .touchDown)
            self.toSearchBox.addTarget(delegate, action: #selector(StationSearchBarDelegate.onTapToBox), for: .touchDown)
        }
    }
    var fromBoxHeight: NSLayoutConstraint?
    var fromToBoxHeight: NSLayoutConstraint?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor("#E0E0E0")
        self.fromBoxHeight = self.heightAnchor.constraint(equalToConstant: 40)
        self.fromToBoxHeight = self.heightAnchor.constraint(equalToConstant: 72)

        placeFromSearchBox()
    }

    private func placeFromSearchBox() {
        self.fromSearchBox.leftViewMode = .always
        self.fromSearchBox.leftView = UIImageView(image: searchIcon)
        self.fromSearchBox.rightView = UIImageView(image: locatingIcon)
        self.fromSearchBox.rightViewMode = .always
        self.fromSearchBox.isUserInteractionEnabled = true

        self.addSubview(self.fromSearchBox)
        self.fromToBoxHeight?.isActive = false
        self.fromBoxHeight?.isActive = true
        NSLayoutConstraint.activate([
            self.fromSearchBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5), //5
            self.fromSearchBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5), // -5
            self.fromSearchBox.topAnchor.constraint(equalTo: self.topAnchor, constant: 5), // 5, 0
            self.fromSearchBox.heightAnchor.constraint(equalToConstant: 30)
        ])
        self.sizeToFit()
    }

    private func placeToSearchBox() {
        self.toSearchBox.rightViewMode = .always
        self.toSearchBox.leftView = UIImageView(image: searchIcon)
        self.toSearchBox.addGestureRecognizer(UITapGestureRecognizer(target: self.delegate, action: #selector(self.delegate?.onTapToBox)))
        self.addSubview(self.toSearchBox)

        self.fromBoxHeight?.isActive = false
        self.fromToBoxHeight?.isActive = true
        NSLayoutConstraint.activate([
            self.toSearchBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.toSearchBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.toSearchBox.topAnchor.constraint(equalTo: self.fromSearchBox.bottomAnchor, constant: 2), // 5, 0
            self.toSearchBox.heightAnchor.constraint(equalToConstant: 30)
        ])
        self.sizeToFit()
    }

    func reloadStation(from station: Station, to destination: Station?) {
        self.fromSearchBox.text = station.name
        self.fromSearchBox.leftViewMode = .never

        if !self.toSearchBox.isDescendant(of: self) {
            placeToSearchBox()
            self.fromSearchBox.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.toSearchBox.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }

        if let dst = destination {
            self.toSearchBox.text = dst.name
            self.toSearchBox.leftViewMode = .never
        } else {
            self.toSearchBox.text = nil
            self.toSearchBox.leftViewMode = .always
            self.toSearchBox.leftViewMode = .always
        }
    }

}

class SearchBoxField: UITextField {

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.center.x - 50, y: 0, width: 100, height: bounds.height)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.center.x - 65, y: bounds.height / 2 - 10, width: 20, height: 20)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.maxX - 30, y: bounds.height / 2 - 10, width: 20, height: 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.borderColor = UIColor("#D0D0D0").cgColor
        self.layer.cornerRadius = 10
        self.textAlignment = .center
    }

    func withPlaceholder(placeholder: String) -> SearchBoxField {
        self.placeholder = placeholder
        return self
    }
}

@objc protocol StationSearchBarDelegate {
    @objc func onTapFromBox(textField: UITextField)

    @objc func onTapToBox(textField: UITextField)
}