//
// Created by Zhou, Hongfei on 8/10/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons
import PinLayout

class StationSearchBar: UIView, UITextFieldDelegate {
    var fromSearchBox = SearchBoxField().withPlaceholder(placeholder: "Station")
    var toSearchBox = SearchBoxField().withPlaceholder(placeholder: "Destination")
    var deleteButton = UIButton()
    var delegate: StationSearchBarDelegate? {
        didSet {
            self.fromSearchBox.addTarget(delegate, action: #selector(StationSearchBarDelegate.onTapFromBox), for: .touchDown)
            self.toSearchBox.addTarget(delegate, action: #selector(StationSearchBarDelegate.onTapToBox), for: .touchDown)
            self.deleteButton.addTarget(delegate, action: #selector(StationSearchBarDelegate.onDeleteTopBoxContent), for: .touchDown)
        }
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

//        self.backgroundColor = UIColor("#E0E0E0")
        self.backgroundColor = .white
        
        self.fromSearchBox.leftViewMode = .always
        self.fromSearchBox.leftView = UIImageView(image: Icons.search)
        self.fromSearchBox.isUserInteractionEnabled = true
        self.fromSearchBox.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

        self.toSearchBox.rightViewMode = .always
        self.toSearchBox.leftView = UIImageView(image: Icons.search)
        self.deleteButton.setImage(Icons.delete, for: .normal)
        self.toSearchBox.rightView = deleteButton
        self.toSearchBox.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.6

        self.addSubview(self.fromSearchBox)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.fromSearchBox.pin.horizontally(pin.safeArea).top(pin.safeArea).height(40)
        pin.wrapContent(padding: pin.safeArea)
    }

    private func placeToSearchBox() {
        self.addSubview(self.toSearchBox)
        self.toSearchBox.pin.horizontally(pin.safeArea).below(of: self.fromSearchBox).height(40)
        pin.wrapContent(padding: pin.safeArea)
    }

    func reloadStation(from station: Station?, to destination: Station?) {
        guard let stnt = station else { return }

        self.fromSearchBox.text = stnt.name
        self.fromSearchBox.leftViewMode = .never

        if !self.toSearchBox.isDescendant(of: self) {
            placeToSearchBox()
            self.fromSearchBox.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.toSearchBox.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }

        if let dst = destination {
            self.toSearchBox.text = dst.name
            self.toSearchBox.leftViewMode = .never
            self.toSearchBox.rightViewMode = .always
        } else {
            self.toSearchBox.text = nil
            self.toSearchBox.leftViewMode = .always
            self.toSearchBox.rightViewMode = .never
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

        self.backgroundColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 10
        self.textAlignment = .center
        self.font = FontUtil.pingFangTCRegular(size: 18)
    }

    func withPlaceholder(placeholder: String) -> SearchBoxField {
        self.placeholder = placeholder
        return self
    }
}

@objc protocol StationSearchBarDelegate {
    @objc func onTapFromBox(textField: UITextField)

    @objc func onTapToBox(textField: UITextField)

    @objc func onDeleteTopBoxContent()
}
