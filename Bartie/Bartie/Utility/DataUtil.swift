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
        BartStationService.getAllStationMap() { stationsMap in
            let stations = choppedStations.map({ stnt in stationsMap[stnt] }).filter({ stnt in stnt != nil }).map({ stnt in stnt! })
            completionHandler(stations)
        }
    }
    
    class func findClosestDeparture(in departures: [Departure], for trip: Trip) -> Departure? {
        return departures.filter({ departure in
            guard let leg = trip.leg.first, let departureTime = Int(departure.minutes), let delaySeconds = Int(departure.delay) else { return false }
            let sameDestination = leg.trainHeadStation == departure.abbreviation
            let tripTime = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            let regulatedDeparture = departureTime - delaySeconds / 60
            let inTimeRange = tripTime - 5 < regulatedDeparture && regulatedDeparture < tripTime + 5
            return sameDestination && inTimeRange
        }).min(by: { (dep1, dep2) in
            guard let depTime1 = Int(dep1.minutes), let depTime2 = Int(dep2.minutes) else { return false }
            let tripDiff = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            return abs(depTime1 - tripDiff) < abs(depTime2 - tripDiff)
        })
    }

    class func findClosestTrip(in trips: [Trip], for departure: Departure) -> Trip? {
        guard let departureMinutes = Int(departure.minutes) else { return nil }
        return trips.filter({ trip in
            let tripTime = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            let inTimeRange = departureMinutes - 15 < tripTime && tripTime < departureMinutes + 15
            return inTimeRange
        }).min(by: { (trip1, trip2) in
            let tripDiff1 = DateUtil.getTimeDifferenceToNow(dateString: trip1.origTimeDate + trip1.origTimeMin)
            let tripDiff2 = DateUtil.getTimeDifferenceToNow(dateString: trip2.origTimeDate + trip2.origTimeMin)
            return abs(tripDiff1 - departureMinutes) < abs(tripDiff2 - departureMinutes)
        })
    }

    class func clipStations(for trip: Trip) -> [(String, String)]{
        var allOrigins = trip.leg.map({ l in (l.origin, l.origTimeMin)})
        if let last = trip.leg.last.map({ l in (l.destination, l.destTimeMin)}) {
            allOrigins.append(last)
        }

        return allOrigins
    }


    class func getClosestStation(in stations: [Station], to location: CLLocation) -> Station? {
        return stations.min(by: { (s1, s2) in
            guard let latitudeS1 = Double(s1.gtfs_latitude), let longitudeS1 = Double(s1.gtfs_longitude),
                    let latitudeS2 = Double(s2.gtfs_latitude), let longitudeS2 = Double(s2.gtfs_longitude) else {
                return false
            }
            let coordinate1 = CLLocation(latitude: latitudeS1, longitude: longitudeS1)
            let coordinate2 = CLLocation(latitude: latitudeS2, longitude: longitudeS2)
            return coordinate1.distance(from: location) < coordinate2.distance(from: location)
        })
    }
    
    class func regulateTripsWithDepartures(for trips: [Trip], with departures: [Departure]) -> [(Trip, Departure?)] {
        let regulatedTrips = trips.map({ trip in (trip, findClosestDeparture(in: departures, for: trip))})
        
        if let first = regulatedTrips.first {
            if first.1 == nil {
                return Array(regulatedTrips.dropFirst())
            }
        }
        
        return regulatedTrips
    }
}
