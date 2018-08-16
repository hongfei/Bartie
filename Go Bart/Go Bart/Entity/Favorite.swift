//
// Created by Hongfei on 2018/8/15.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class Favorite: Codable {
    let station: Station
    let destination: Station

    init(from station: Station, to destination: Station) {
        self.station = station
        self.destination = destination
    }
}
