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
                guard let estimateDepartures = JSON(jsonResult)["root"]["station"][0]["etd"].array?.map({ json in
                    return try? decoder.decode(EstimatedDeparture.self, from: json.rawData())
                }) else { return }
                
                let deps: [Departure] = estimateDepartures.reduce([], { (result: [Departure], estimateDeparture: EstimatedDeparture?) in
                    guard let estDep = estimateDeparture else {
                        return result
                    }
                    
                    return result + estDep.estimate.map { est in
                        est.destination = estDep.destination
                        est.abbreviation = estDep.abbreviation
                        est.minutes = est.minutes == "Leaving" ? "0" : est.minutes
                        return est
                    }
                })

                let sortedDeps = deps.sorted(by: { dep1, dep2 in
                    guard let min1 = Int(dep1.minutes), let min2 = Int(dep2.minutes) else { return true }
                    return min1 < min2
                })
                return completionHandler(sortedDeps)
                
            }
            completionHandler([])
        }
    }
}
