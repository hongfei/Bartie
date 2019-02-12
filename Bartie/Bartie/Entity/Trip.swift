//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class Trip: Codable {
    var origin: String
    var destination: String
    var fare: String
    var origTimeMin: String
    var origTimeDate: String
    var destTimeMin: String
    var destTimeDate: String
    var tripTime: String
    var leg: [Legend]

    init(origin: String, destination: String, fare: String, origTimeMin: String, origTimeDate: String,
         destTimeMin: String, destTimeDate: String, clipper: String, tripTime: String, leg: [Legend]) {
        self.origin = origin
        self.destination = destination
        self.fare = fare
        self.origTimeMin = origTimeMin
        self.origTimeDate = origTimeDate
        self.destTimeMin = destTimeMin
        self.destTimeDate = destTimeDate
        self.tripTime = tripTime
        self.leg = leg
    }

    private enum CodingKeys: String, CodingKey {
        case origin = "@origin"
        case destination = "@destination"
        case fare = "@fare"
        case origTimeMin = "@origTimeMin"
        case origTimeDate = "@origTimeDate"
        case destTimeMin = "@destTimeMin"
        case destTimeDate = "@destTimeDate"
        case tripTime = "@tripTime"
        case leg = "leg"
    }

}

class Fares: Codable {
    var fare: [Fare]

    init(fare: [Fare]) {
        self.fare = fare
    }

    private enum CodingKeys: String, CodingKey {
        case fare = "fare"
    }
}

class Fare: Codable {
    var amount: String
    var fareClass: String
    var name: String

    init(amount: String, fareClass: String, name: String) {
        self.amount = amount
        self.fareClass = fareClass
        self.name = name
    }

    private enum CodingKeys: String, CodingKey {
        case amount = "@amount"
        case fareClass = "@class"
        case name = "@name"
    }
}

class Legend: Codable {
    var order: String
    var origin: String
    var destination: String
    var origTimeMin: String
    var origTimeDate: String
    var destTimeMin: String
    var destTimeDate: String
    var line: String
    var bikeflag: String
    var trainHeadStation: String
    var load: String

    init(order: String, origin: String, destination: String, origTimeMin: String,
         origTimeDate: String, destTimeMin: String, destTimeDate: String, line: String, bikeflag: String,
         trainHeadStation: String, load: String) {
        self.order = order
        self.origin = origin
        self.destination = destination
        self.origTimeMin = origTimeMin
        self.origTimeDate = origTimeDate
        self.destTimeMin = destTimeMin
        self.destTimeDate = destTimeDate
        self.line = line
        self.bikeflag = bikeflag
        self.trainHeadStation = trainHeadStation
        self.load = load
    }

    private enum CodingKeys: String, CodingKey {
        case order = "@order"
        case origin = "@origin"
        case destination = "@destination"
        case origTimeMin = "@origTimeMin"
        case origTimeDate = "@origTimeDate"
        case destTimeMin = "@destTimeMin"
        case destTimeDate = "@destTimeDate"
        case line = "@line"
        case bikeflag = "@bikeflag"
        case trainHeadStation = "@trainHeadStation"
        case load = "@load"
    }
}
