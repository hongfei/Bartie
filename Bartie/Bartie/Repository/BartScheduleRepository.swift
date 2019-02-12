//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartScheduleRepository {
    private static let SCHEDULE_RESOURCE = "/sched.aspx"
    private static let decoder = JSONDecoder()

    static func getTripPlan(from: Station, to: Station, beforeCount: Int = 0, afterCount: Int = 3, completionHandler: @escaping ([Trip]?) -> Void) {
        BartService.getResponse(
                for: SCHEDULE_RESOURCE,
                withParams: ["cmd": "depart", "orig": from.abbr, "dest": to.abbr, "a": String(afterCount), "b": String(beforeCount)]
        ) { response in
            guard let jsonResponse = response else {
                return completionHandler(nil)
            }
            guard let jsonArray = JSON(jsonResponse)["root"]["schedule"]["request"]["trip"].array else {
                return completionHandler([])
            }

            let trips = jsonArray.map({ json in return try? decoder.decode(Trip.self, from: json.rawData()) })
                    .filter({ trip in trip != nil }).map({ trip in trip! })
            completionHandler(trips)
        }
    }

    static func getTripFare(from station: String, to destination: String, date: String, completionHandler: @escaping ([Fare]) -> Void) {
        BartService.getResponse(
                for: SCHEDULE_RESOURCE,
                withParams: ["cmd": "fare", "orig": station, "dest": destination, "date": date]) { response in
            guard let jsonResponse = response else {
                return completionHandler([])
            }

            guard let jsonArray = JSON(jsonResponse)["root"]["fares"]["fare"].array else {
                return completionHandler([])
            }

            let fares = jsonArray.map({ json in return try? decoder.decode(Fare.self, from: json.rawData()) })
                    .filter({ fare in fare != nil }).map({ fare in fare! })
            completionHandler(fares)
        }
    }
}
