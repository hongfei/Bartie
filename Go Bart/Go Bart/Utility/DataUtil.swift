//
// Created by Hongfei on 2018/8/11.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class DataUtil {
    class func extractStations(for routeDetail: DetailRoute, from stationAbbr: String, to destinationAbbr: String, completionHandler: @escaping ([Station]) -> Void) {
        let stations = routeDetail.config.station
        let start = stations.index(of: stationAbbr)!
        let end = stations.index(of: destinationAbbr)!
        var choppedStations: [String] = []
        if start < end {
            choppedStations = Array(stations[start...end])
        } else {
            choppedStations = Array(stations[end...start]).reversed()
        }

        BartStationService.getAllStationMap() { stationsMap in
            completionHandler(choppedStations.map( { stnt in stationsMap[stnt]! }))
        }
    }
    
    class func findClosestDeparture(in departures: [Departure], for trip: Trip) -> Departure? {
        return departures.filter({ departure in
            return departure.abbreviation == trip.leg.first!.trainHeadStation
        }).min(by: { (dep1, dep2) in
            let tripDiff = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            return abs(Int(dep1.minutes)! - tripDiff) < abs(Int(dep2.minutes)! - tripDiff)
        })
    }

    class func findClosestTrip(in trips: [Trip], for departure: Departure) -> Trip? {
        return trips.filter({ trip in
            trip.leg.first!.trainHeadStation == departure.abbreviation! &&
                    abs(DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin) - Int(departure.minutes)!) < 10
        }).min(by: { (trip1, trip2) in
            let tripDiff1 = DateUtil.getTimeDifferenceToNow(dateString: trip1.origTimeDate + trip1.origTimeMin)
            let tripDiff2 = DateUtil.getTimeDifferenceToNow(dateString: trip2.origTimeDate + trip2.origTimeMin)
            return abs(tripDiff1 - Int(departure.minutes)!) < abs(tripDiff2 - Int(departure.minutes)!)
        })
    }

    class func clipStations(for trip: Trip) -> ((String, String), [(String, String)], (String, String)) {
        let allOrigins = trip.leg.map({ l in (l.origin, l.origTimeMin)})

        guard let first = allOrigins.first else {
            return (("NON", "0"), [], ("NON", "0"))
        }

        let last = trip.leg.last.map({ l in (l.destination, l.destTimeMin)})!
        return (first, Array(allOrigins.dropFirst()), last)
    }
}
