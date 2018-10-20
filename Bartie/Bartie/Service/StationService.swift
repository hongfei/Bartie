//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import CoreLocation

class StationService {
    class func getAllStations(completionHandler: @escaping ([Station]) -> Void) {
        if let stations = CacheStationRepository.getStations() {
            return completionHandler(stations)
        }

        BartStationRepository.getStations { stations in
            CacheStationRepository.storeStations(stations: stations)
            completionHandler(stations)
        }
    }

    class func getAllStationMap(completionHandler: @escaping ([String: Station]) -> Void) {
        if let stationsMap = CacheStationRepository.getStationsMap() {
            return completionHandler(stationsMap)
        }

        BartStationRepository.getStations { stations in
            CacheStationRepository.storeStations(stations: stations)

            if let stationsMap = CacheStationRepository.getStationsMap() {
                return completionHandler(stationsMap)
            } else {
                return completionHandler([:])
            }
        }
    }

    class func getStation(by abbr: String, completionHandler: @escaping (Station) -> Void) {
        getAllStationMap() { stationsMap in
            if let station = stationsMap[abbr] {
                completionHandler(station)
            }
        }
    }

    class func getClosestStation(from location: CLLocation, completionHandler: @escaping (Station) -> Void) {
        getAllStations() { stations in
            if let closestStation = stations.min(by: { (s1, s2) in
                guard let latitudeS1 = Double(s1.gtfs_latitude), let longitudeS1 = Double(s1.gtfs_longitude),
                      let latitudeS2 = Double(s2.gtfs_latitude), let longitudeS2 = Double(s2.gtfs_longitude) else {
                    return false
                }
                let coordinate1 = CLLocation(latitude: latitudeS1, longitude: longitudeS1)
                let coordinate2 = CLLocation(latitude: latitudeS2, longitude: longitudeS2)
                return coordinate1.distance(from: location) < coordinate2.distance(from: location)
            }) {
                completionHandler(closestStation)
            }
        }
    }

}
