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
    var clipper: String
    var tripTime: String
    var co2: String
    var fares: Fares
    var leg: [Legend]

    init(origin: String, destination: String, fare: String, origTimeMin: String, origTimeDate: String,
         destTimeMin: String, destTimeDate: String, clipper: String, tripTime: String, co2: String, fares: Fares,
         leg: [Legend]) {
        self.origin = origin
        self.destination = destination
        self.fare = fare
        self.origTimeMin = origTimeMin
        self.origTimeDate = origTimeDate
        self.destTimeMin = destTimeMin
        self.destTimeDate = destTimeDate
        self.clipper = clipper
        self.tripTime = tripTime
        self.co2 = co2
        self.fares = fares
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
        case clipper = "@clipper"
        case tripTime = "@tripTime"
        case co2 = "@co2"
        case fares = "fares"
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
    var transfercode: String
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
    var trainId: String
    var trainIdx: String

    init(order: String, transfercode: String, origin: String, destination: String, origTimeMin: String,
         origTimeDate: String, destTimeMin: String, destTimeDate: String, line: String, bikeflag: String,
         trainHeadStation: String, load: String, trainId: String, trainIdx: String) {
        self.order = order
        self.transfercode = transfercode
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
        self.trainId = trainId
        self.trainIdx = trainIdx
    }

    private enum CodingKeys: String, CodingKey {
        case order = "@order"
        case transfercode = "@transfercode"
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
        case trainId = "@trainId"
        case trainIdx = "@trainIdx"
    }
}