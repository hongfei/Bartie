//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import Cache

class DataCache {
    private static let diskConfig = DiskConfig(
            name: "DiskWeekCache",
            expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 7)),
            maxSize: 10000,
            protectionType: .complete
    )
    private static let memoryConfig = MemoryConfig(
            expiry: .date(Date().addingTimeInterval(2 * 60)),
            countLimit: 50,
            totalCostLimit: 0
    )
    private static let stationStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: [Station].self))
    private static let routeStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: [Route].self))
    private static let detailRouteStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: DetailRoute.self))

    static func storeStations(stations: [Station]) {
        try? stationStorage?.setObject(stations, forKey: "stations")
    }

    static func getStations() -> [Station]? {
        if let stations = try? stationStorage?.entry(forKey: "stations").object {
            return stations
        } else {
            return nil
        }
    }
    
    static func storeAllRoutes(routes: [Route]) {
        try? routeStorage?.setObject(routes, forKey: "routes")
    }

    static func getAllRoutes() -> [Route]? {
        if let routes = try? routeStorage?.entry(forKey: "routes").object {
            return routes
        } else {
            return nil
        }
    }

    static func storeDetailRoutes(route: DetailRoute) {
        try? detailRouteStorage?.setObject(route, forKey: "detail_route_" + route.routeID)
    }

    static func getDetailRoute(routeID: String) -> DetailRoute? {
        if let detailRoute = try? detailRouteStorage?.entry(forKey: "detail_route_" + routeID).object {
            return detailRoute
        } else {
            return nil
        }
    }
}
