//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartRealTimeRepository {
    private static let REALTIME_RESOURCE = "/etd.aspx"
    private static let decoder = JSONDecoder()

    class func getDepartures(for stationAbbr: String, completionHandler: @escaping ([Departure]?) -> Void) {
        BartService.getResponse(for: REALTIME_RESOURCE, withParams: ["cmd": "etd", "orig": stationAbbr]) { result in
            guard let jsonResult = result else {
                return completionHandler(nil)
            }

            guard let estimateDepartures = JSON(jsonResult)["root"]["station"][0]["etd"].array?.map({ json in
                return try? decoder.decode(EstimatedDeparture.self, from: json.rawData())
            }) else {
                return completionHandler([])
            }

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

            return completionHandler(deps)
        }
    }
}
