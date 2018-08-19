//
// Created by Hongfei on 2018/8/11.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import CoreLocation

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
            let sameDestination = trip.leg.first!.trainHeadStation == departure.abbreviation!
            let tripTime = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            let departureTime = Int(departure.minutes)!
            let inTimeRange = tripTime - 15 < departureTime && departureTime < tripTime + 15
            return sameDestination && inTimeRange
        }).min(by: { (dep1, dep2) in
            let tripDiff = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            return abs(Int(dep1.minutes)! - tripDiff) < abs(Int(dep2.minutes)! - tripDiff)
        })
    }

    class func findClosestTrip(in trips: [Trip], for departure: Departure) -> Trip? {
        return trips.filter({ trip in
            let tripTime = DateUtil.getTimeDifferenceToNow(dateString: trip.origTimeDate + trip.origTimeMin)
            let departureTime = Int(departure.minutes)!
            let inTimeRange = departureTime - 15 < tripTime && tripTime < departureTime + 15
            return inTimeRange
        }).min(by: { (trip1, trip2) in
            let tripDiff1 = DateUtil.getTimeDifferenceToNow(dateString: trip1.origTimeDate + trip1.origTimeMin)
            let tripDiff2 = DateUtil.getTimeDifferenceToNow(dateString: trip2.origTimeDate + trip2.origTimeMin)
            return abs(tripDiff1 - Int(departure.minutes)!) < abs(tripDiff2 - Int(departure.minutes)!)
        })
    }

    class func clipStations(for trip: Trip) -> [(String, String)]{
        var allOrigins = trip.leg.map({ l in (l.origin, l.origTimeMin)})
        let last = trip.leg.last.map({ l in (l.destination, l.destTimeMin)})!

        allOrigins.append(last)
        return allOrigins
    }


    class func getClosestStation(in stations: [Station], to location: CLLocation) -> Station? {
        return stations.min(by: { (s1, s2) in
            let coordinate1 = CLLocation(latitude: Double(s1.gtfs_latitude)!, longitude: Double(s1.gtfs_longitude)!)
            let coordinate2 = CLLocation(latitude: Double(s2.gtfs_latitude)!, longitude: Double(s2.gtfs_longitude)!)
            return coordinate1.distance(from: location) < coordinate2.distance(from: location)
        })
    }
}
