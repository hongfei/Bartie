//
// Created by Hongfei on 2018/8/6.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class FromStationLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = "From"
    }
}

class ToStationLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = "To"
    }
}

class FromStation: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.darkGray
        self.isUserInteractionEnabled = true
    }
}

class ToStation: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.lightGray
        self.isUserInteractionEnabled = true
    }
}