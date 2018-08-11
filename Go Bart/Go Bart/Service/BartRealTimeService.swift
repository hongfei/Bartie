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
                    let deps: [Departure] = departures.reduce([], { (result: [Departure], departure: EstimatedDeparture) in
                        result + departure.estimate.enumerated().map { (index, dep) in
                            dep.destination = departure.destination
                            dep.abbreviation = departure.abbreviation
                            if dep.minutes == "Leaving" {
                                dep.minutes = "0"
                            }
                            return dep
                        }
                    })

                    let sortedDeps = deps.sorted(by: { dep1, dep2 in
                        guard let min1 = Int(dep1.minutes) else {
                            return true
                        }
                        guard let min2 = Int(dep2.minutes) else {
                            return true
                        }

                        return min1 < min2
                    })
                    return completionHandler(sortedDeps)
                }
            }
            completionHandler([])
        }
    }
}
