//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class ScheduleService {
    class func getTripPlan(from station: Station, to destination: Station, beforeCount: Int = 0, afterCount: Int = 3, completionHandler: @escaping ([Trip]) -> Void) {
        BartScheduleRepository.getTripPlan(from: station, to: destination) { trips in
            let validTrips = trips.filter({ trip in DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin ) > -10 })
            completionHandler(validTrips)
        }
    }
}
