//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class Station {
    var name: String
    var abbr: String
    var latitude: String
    var longitude: String
    var address: String
    var city: String
    var county: String
    var state: String
    var zipcode: String

    init(name: String, abbr: String, latitude: String, longitude: String, address: String, city: String, county: String, state: String, zipcode: String) {
        self.name = name
        self.abbr = abbr
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.city = city
        self.county = county
        self.state = state
        self.zipcode = zipcode
    }

    convenience init() {
        self.init(name: "", abbr: "", latitude: "", longitude: "", address: "", city: "", county: "", state: "", zipcode: "")
    }
    convenience init(with json: JSON) {
        self.init(
                name: json["name"].string!,
                abbr: json["abbr"].string!,
                latitude: json["gtfs_latitude"].string!,
                longitude: json["gtfs_longitude"].string!,
                address: json["address"].string!,
                city: json["city"].string!,
                county: json["county"].string!,
                state: json["state"].string!,
                zipcode: json["zipcode"].string!
        )
    }
}
