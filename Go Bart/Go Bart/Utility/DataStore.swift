//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class DataStore {
    private static let STATION_FILE = "/cache/stations.plist"
    private static let ROUTE_FILE_PREFIX = "/cache/routes/"

    static func storeStations(stations: [Station]) {
        NSKeyedArchiver.archiveRootObject(stations, toFile: STATION_FILE)
    }
    
    static func storeRoute(route: Route) {
        NSKeyedArchiver.archiveRootObject(route, toFile: ROUTE_FILE_PREFIX + route.routeID)
    }

    static func retrieveStations() -> [Station] {
        if let stations = NSKeyedUnarchiver.unarchiveObject(withFile: STATION_FILE) as? [Station] {
            return stations
        } else {
            return []
        }
    }

    static func retrieveRoute(routeID: String) -> Route? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ROUTE_FILE_PREFIX + routeID) as? Route
    }
}
