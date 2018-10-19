//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class RealTimeService: BartService {
    static let REALTIME_RESOURCE = "/etd.aspx"
    static let decoder = JSONDecoder()

    class func getSelectedDepartures(for station: Station, completionHandler: @escaping ([Departure]) -> Void) {
        getDepartures(for: station.abbr, completionHandler: completionHandler)
    }

    class func getAllDepartures(completionHandler: @escaping ([Departure]) -> Void) {
        getDepartures(for: "ALL", completionHandler: completionHandler)
    }

    private class func getDepartures(for stationAbbr: String, completionHandler: @escaping ([Departure]) -> Void) {
        BartRealTimeRepository.getDepartures(for: stationAbbr) { departures in
            let sortedDeps = departures.sorted(by: { dep1, dep2 in
                guard let min1 = Int(dep1.minutes), let min2 = Int(dep2.minutes) else {
                    return true
                }
                return min1 < min2
            })
            return completionHandler(sortedDeps)
        }
    }
}
