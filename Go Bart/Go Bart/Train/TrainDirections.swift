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
    var stationTapDelegate: StationTapDelegate!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false

        placeFromLabel()
        placeFromStation()
    }

    private func placeFromLabel() {
        fromLabel = UILabel()
        fromLabel.text = "From"
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(fromLabel)

        NSLayoutConstraint.activate([
            fromLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fromLabel.topAnchor.constraint(equalTo: self.topAnchor),
            fromLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    public func placeFromStation() {
        fromInput = UILabel()
        fromInput.text = "Not Implemented"
        fromInput.backgroundColor = UIColor.darkGray
        fromInput.translatesAutoresizingMaskIntoConstraints = false
        fromInput.isUserInteractionEnabled = true
        fromInput.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFromInputClicked)))
        self.addSubview(fromInput)

        NSLayoutConstraint.activate([
            fromInput.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor),
            fromInput.topAnchor.constraint(equalTo: self.topAnchor),
            fromInput.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            fromInput.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    public func placeToLabel() {
        
    }
    
    public func placeToStation() {
        
    }
    
    @objc func onFromInputClicked(_ sender: UITapGestureRecognizer) {
        self.stationTapDelegate.openStationPicker(on: sender.view!)
    }
}

protocol StationTapDelegate {
    func openStationPicker(on sender: UIView)
}

