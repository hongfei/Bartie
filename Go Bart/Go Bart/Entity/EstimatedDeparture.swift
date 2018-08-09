//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIColor_Hex_Swift

class EstimatedDeparture {
    let destination: String
    let abbreviation: String
    let estimate: [Departure]

    init(destination: String, abbreviation: String, estimate: [Departure]) {
        self.destination = destination
        self.abbreviation = abbreviation
        self.estimate = estimate
    }

    convenience init() {
        self.init(destination: "", abbreviation: "", estimate: [])
    }

    convenience init(with json: JSON) {
        let dst = json["destination"].string!
        let abbr = json["abbreviation"].string!
        self.init(
                destination: dst,
                abbreviation: abbr,
                estimate: json["estimate"].array!.map { json in Departure(destination: dst, abbreviation: abbr, with: json) }
        )
    }
}

class Departure {
    let destination: String
    let abbreviation: String
    let minutes: String
    let platform: String
    let direction: String
    let length: Int
    let color: UIColor
    let bikeAllowed: Bool
    let delay: Int

    init(destination: String, abbreviation: String, minutes: String, platform: String, direction: String, length: Int,
         color: UIColor, bikeAllowed: Bool, delay: Int) {
        self.destination = destination
        self.abbreviation = abbreviation
        self.minutes = minutes
        self.platform = platform
        self.direction = direction
        self.length = length
        self.color = color
        self.bikeAllowed = bikeAllowed
        self.delay = delay
    }

    convenience init() {
        self.init(destination: "", abbreviation: "", minutes: "0", platform: "", direction: "", length: 0, color: UIColor.white, bikeAllowed: true, delay: 0)
    }

    convenience init(destination: String, abbreviation: String, with json: JSON) {
        self.init(
                destination: destination,
                abbreviation: abbreviation,
                minutes: json["minutes"].string!,
                platform: json["platform"].string!,
                direction: json["direction"].string!,
                length: Int(json["length"].string!)!,
                color: UIColor(json["hexcolor"].string!),
                bikeAllowed: Int(json["bikeflag"].string!)! == 1,
                delay: Int(json["delay"].string!)!
        )
    }

}
