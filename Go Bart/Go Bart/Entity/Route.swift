//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class Route: Codable {
    let name: String
    let abbr: String
    let routeID: String
    let number: String
    let hexcolor: String
    let color: String

    init(name: String, abbr: String, routeID: String, number: String, hexcolor: String, color: String) {
        self.name = name
        self.abbr = abbr
        self.routeID = routeID
        self.number = number
        self.hexcolor = hexcolor
        self.color = color
    }

}

class DetailRoute: Codable {
    let name: String
    let abbr: String
    let routeID: String
    let number: String
    let hexColor: String
    let color: String
    let origin: String
    let destination: String
    let direction: String
    let holidays: String
    let num_stns: String
    let config: RouteConfig

    init(name: String, abbr: String, routeID: String, number: String, hexColor: String, color: String, origin: String,
         destination: String, direction: String, holidays: String, num_stns: String, config: RouteConfig) {
        self.name = name
        self.abbr = abbr
        self.routeID = routeID
        self.number = number
        self.hexColor = hexColor
        self.color = color
        self.origin = origin
        self.destination = destination
        self.direction = direction
        self.holidays = holidays
        self.num_stns = num_stns
        self.config = config
    }
}

class RouteConfig: Codable {
    let station: [String]

    init(station: [String]) {
        self.station = station
    }
}
