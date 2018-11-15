//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class RealTimeService {
    class func getSelectedDepartures(for station: Station, completionHandler: @escaping ([Departure]?) -> Void) {
        getDepartures(for: station.abbr, completionHandler: completionHandler)
    }

    class func getAllDepartures(completionHandler: @escaping ([Departure]?) -> Void) {
        getDepartures(for: "ALL", completionHandler: completionHandler)
    }
    
    class func findClosestDeparture(in departures: [Departure], for trip: Trip) -> Departure? {
        return departures.filter({ departure in
            guard let leg = trip.leg.first, let departureTime = Int(departure.minutes), let delaySeconds = Int(departure.delay) else {
                return false
            }
            let sameDestination = leg.trainHeadStation == departure.abbreviation
            let tripTime = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            let regulatedDeparture = departureTime - delaySeconds / 60
            let inTimeRange = tripTime - 5 < regulatedDeparture && regulatedDeparture < tripTime + 5
            return sameDestination && inTimeRange
        }).min(by: { (dep1, dep2) in
            guard let depTime1 = Int(dep1.minutes), let depTime2 = Int(dep2.minutes) else {
                return false
            }
            let tripDiff = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            return abs(depTime1 - tripDiff) < abs(depTime2 - tripDiff)
        })
    }

    private class func getDepartures(for stationAbbr: String, completionHandler: @escaping ([Departure]?) -> Void) {
        BartRealTimeRepository.getDepartures(for: stationAbbr) { departures in
            let sortedDeps = departures?.sorted(by: { dep1, dep2 in
                guard let min1 = Int(dep1.minutes), let min2 = Int(dep2.minutes) else {
                    return true
                }
                return min1 < min2
            })
            return completionHandler(sortedDeps)
        }
    }
}
