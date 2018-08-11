//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class EstimatedDeparture: Codable {
    let destination: String
    let abbreviation: String
    let estimate: [Departure]

    init(destination: String, abbreviation: String, estimate: [Departure]) {
        self.destination = destination
        self.abbreviation = abbreviation
        self.estimate = estimate
    }

}

class Departure: Codable {
    var destination: String?
    var abbreviation: String?
    var minutes: String
    let platform: String
    let direction: String
    let length: String
    let color: String
    let hexcolor: String
    let bikeflag: String
    let delay: String

    init(destination: String, abbreviation: String, minutes: String, platform: String, direction: String, length: String,
         color: String, hexcolor: String, bikeflag: String, delay: String) {
        self.destination = destination
        self.abbreviation = abbreviation
        self.minutes = minutes
        self.platform = platform
        self.direction = direction
        self.length = length
        self.color = color
        self.hexcolor = hexcolor
        self.bikeflag = bikeflag
        self.delay = delay
    }

}
