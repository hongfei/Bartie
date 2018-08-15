//
// Created by Hongfei on 2018/8/14.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailContentList: UITableView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bounces = false
        self.register(RouteDetailMapView.self, forCellReuseIdentifier: "RouteDetailMapView")
        self.register(SingleTripView.self, forCellReuseIdentifier: "SingleTripView")
    }
}
