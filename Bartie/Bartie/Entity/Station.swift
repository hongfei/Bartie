//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class Station: Codable {
    let name: String
    let abbr: String
    let gtfs_latitude: String
    let gtfs_longitude: String
    let address: String
    let city: String
    let county: String
    let state: String
    let zipcode: String

    init(name: String, abbr: String, gtfs_latitude: String, gtfs_longitude: String, address: String, city: String, county: String,
         state: String, zipcode: String) {
        self.name = name
        self.abbr = abbr
        self.gtfs_latitude = gtfs_latitude
        self.gtfs_longitude = gtfs_longitude
        self.address = address
        self.city = city
        self.county = county
        self.state = state
        self.zipcode = zipcode
    }
}

class StationProperty: Codable {
    var hasToilet: Bool

    init(hasToilet: Bool) {
        self.hasToilet = hasToilet
    }
}