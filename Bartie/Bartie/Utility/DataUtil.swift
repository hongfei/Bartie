//
// Created by Hongfei on 2018/8/11.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import CoreLocation

class DataUtil {
    class func extractStations(for routeDetail: DetailRoute, from stationAbbr: String, to destinationAbbr: String, completionHandler: @escaping ([Station]) -> Void) {
        let stations = routeDetail.config.station
        guard let start = stations.index(of: stationAbbr), let end = stations.index(of: destinationAbbr) else {
            return completionHandler([])
        }

        let choppedStations: [String] = start < end ? Array(stations[start...end]) : Array(stations[end...start]).reversed()
        StationService.getAllStationMap() { stationsMap in
            let stations = choppedStations.map({ stnt in stationsMap[stnt] }).filter({ stnt in stnt != nil }).map({ stnt in stnt! })
            completionHandler(stations)
        }
    }

    class func clipStations(for trip: Trip) -> [(String, String)] {
        var allOrigins = trip.leg.map({ l in (l.origin, l.origTimeMin) })
        if let last = trip.leg.last.map({ l in (l.destination, l.destTimeMin) }) {
            allOrigins.append(last)
        }

        return allOrigins
    }

    class func regulateTripsWithDepartures(for trips: [Trip], with departures: [Departure]) -> [(Trip, Departure?)] {
        let regulatedTrips = trips.map({ trip in (trip, RealTimeService.findClosestDeparture(in: departures, for: trip)) })

        if let first = regulatedTrips.first {
            if first.1 == nil {
                return Array(regulatedTrips.dropFirst())
            }
        }

        return regulatedTrips
    }
}
