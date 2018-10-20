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

    class func getTripsWithDeparture(from station: Station, to destination: Station, beforeCount: Int = 0, afterCount: Int = 3, completionHandler: @escaping ([(Trip, Departure?)]) -> Void) {
        getTripPlan(from: station, to: destination) { trips in
            RealTimeService.getSelectedDepartures(for: station) { departures in
                completionHandler(DataUtil.regulateTripsWithDepartures(for: trips, with: departures))
            }
        }
    }

    class func findClosestTrip(in trips: [Trip], for departure: Departure) -> Trip? {
        guard let departureMinutes = Int(departure.minutes), let delaySeconds = Int(departure.minutes) else {
            return nil
        }
        let regulatedDeparture = departureMinutes - delaySeconds / 60
        return trips.filter({ trip in
            let tripTime = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            let inTimeRange = regulatedDeparture - 15 < tripTime && tripTime < regulatedDeparture + 15
            return inTimeRange
        }).min(by: { (trip1, trip2) in
            let tripDiff1 = DateUtil.getTimeDifferenceToNow(dateString: trip1.origTimeDate + trip1.origTimeMin)
            let tripDiff2 = DateUtil.getTimeDifferenceToNow(dateString: trip2.origTimeDate + trip2.origTimeMin)
            return abs(tripDiff1 - regulatedDeparture) < abs(tripDiff2 - regulatedDeparture)
        })
    }
}
