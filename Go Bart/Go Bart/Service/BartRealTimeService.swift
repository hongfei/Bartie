//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartRealTimeService: BartService {
    static let REALTIME_RESOURCE = "/etd.aspx"
    static let decoder = JSONDecoder()

    public static func getSelectedDepartures(for station: Station, completionHandler: @escaping ([Departure]) -> Void) {
        getDepartures(for: station.abbr, completionHandler: completionHandler)
    }
    
    public static func getAllDepartures(completionHandler: @escaping ([Departure]) -> Void) {
        getDepartures(for: "ALL", completionHandler: completionHandler)
    }

    private static func getDepartures(for stationAbbr: String, completionHandler: @escaping ([Departure]) -> Void) {
        getResponse(for: REALTIME_RESOURCE, withParams: ["cmd": "etd", "orig": stationAbbr]) { result in
            if let jsonResult = result {
                let optionalDepartures = JSON(jsonResult)["root"]["station"][0]["etd"].array?.map { json in
                    return try! decoder.decode(EstimatedDeparture.self, from: json.rawData())
                }
                if let departures = optionalDepartures {
                    let deps = departures.reduce([], { (result: [Departure], departure: EstimatedDeparture) in
                        result + departure.estimate.map { dep in
                            dep.destination = departure.destination
                            dep.abbreviation = departure.abbreviation
                            return dep
                        }
                    })
                    return completionHandler(deps)
                }
            }
            completionHandler([])
        }
    }
}
