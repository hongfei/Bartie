//
// Created by Hongfei on 2018/8/5.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TrainDirections: UIView {

    var fromLabel: UILabel!
    var fromInput: UILabel!
    var toLabel: UILabel!
    var toInput: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addComponents()
    }

    private func addComponents() {
        fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.translatesAutoresizingMaskIntoConstraints = false

        fromInput = UILabel()
        fromInput.text = "Not Implemented"
        fromInput.backgroundColor = UIColor.darkGray
        fromInput.translatesAutoresizingMaskIntoConstraints = false
        fromInput.isUserInteractionEnabled = true

        self.addSubview(fromLabel)
        self.addSubview(fromInput)

        let viewConstraints = [
            fromLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fromLabel.topAnchor.constraint(equalTo: self.topAnchor),
            fromLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            fromInput.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor),
            fromInput.topAnchor.constraint(equalTo: self.topAnchor),
            fromInput.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            fromInput.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]

        NSLayoutConstraint.activate(viewConstraints)
    }
}
