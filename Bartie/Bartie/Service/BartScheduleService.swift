//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartScheduleService: BartService {
    static let SCHEDULE_RESOURCE = "/sched.aspx"
    static let decoder = JSONDecoder()

    static func getTripPlan(from: Station, to: Station, beforeCount: Int = 0, afterCount: Int = 3, completionHandler: @escaping ([Trip]) -> Void) {
        getResponse(
                for: SCHEDULE_RESOURCE,
                withParams: ["cmd": "depart", "orig": from.abbr, "dest": to.abbr, "a": String(afterCount), "b": String(beforeCount)]
        ) { response in
            guard let jsonResponse = response, let jsonArray = JSON(jsonResponse)["root"]["schedule"]["request"]["trip"].array else {
                return completionHandler([])
            }
            
            let trips = jsonArray.map({ json in return try? decoder.decode(Trip.self, from: json.rawData()) })
                .filter({ trip in trip != nil }).map({ trip in trip! })
                    .filter({ trip in DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin ) > -10 })
            completionHandler(trips)
        }
    }
}