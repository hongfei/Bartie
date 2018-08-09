//
// Created by Hongfei on 2018/8/7.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartScheduleService: BartService {
    static let STATION_RESOURCE = "/etd.aspx"

    public static func getDepartureTime(for station: Station, completionHandler: @escaping ([Departure]) -> Void) {
        getResponse(for: STATION_RESOURCE, withParams: ["cmd": "etd", "orig": station.abbr]) { result in
            if let jsonResult = result {
                let optionalDepartures = JSON(jsonResult)["root"]["station"][0]["etd"].array?.map { json in EstimatedDeparture(with: json) }
                if let departures = optionalDepartures {
                    let deps = departures.reduce([], { (result: [Departure], departure: EstimatedDeparture) in
                        result + departure.estimate
                    })
                    return completionHandler(deps)
                }
            }
            completionHandler([])
        }
    }
}
