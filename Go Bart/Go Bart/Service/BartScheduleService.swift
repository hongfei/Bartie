//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartScheduleService: BartService {
    static let SCHEDULE_RESOURCE = "/sched.aspx"
    static let decoder = JSONDecoder()

    static func getTripPlan(from: Station, to: Station, count: Int = 3, completionHandler: @escaping ([Trip]) -> Void) {
        getResponse(
                for: SCHEDULE_RESOURCE,
                withParams: ["cmd": "depart", "orig": from.abbr, "dest": to.abbr, "a": "3", "b": "0"]
        ) { response in
            if let jsonResponse = response {
                let optionalTrips: [Trip]? = JSON(jsonResponse)["root"]["schedule"]["request"]["trip"].array?.map { json in
                    return try! decoder.decode(Trip.self, from: json.rawData())
                }
                if let trips = optionalTrips {
                    return completionHandler(trips)
                }
            }
            completionHandler([])
        }
    }
}
