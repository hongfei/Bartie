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
    private static let persistentConfig = DiskConfig(
            name: "PersistentData",
            expiry: .never,
            maxSize: 100000,
            protectionType: .complete
    )
    private static let stationStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: [Station].self))
    private static let stationMapStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: [String: Station].self))
    private static let routeStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: [Route].self))
    private static let detailRouteStorage = try? DiskStorage(config: diskConfig, transformer: TransformerFactory.forCodable(ofType: DetailRoute.self))
    private static let favoriteStorage = try? DiskStorage(config: persistentConfig, transformer: TransformerFactory.forCodable(ofType: [Favorite].self))

    class func storeStations(stations: [Station]) {
        try? stationStorage?.setObject(stations, forKey: "stations")
    }

    class func getStations() -> [Station]? {
        if let stations = try? stationStorage?.entry(forKey: "stations").object {
            return stations
        } else {
            return nil
        }
    }
    
    class func storeAllRoutes(routes: [Route]) {
        try? routeStorage?.setObject(routes, forKey: "routes")
    }

    class func getAllRoutes() -> [Route]? {
        if let routes = try? routeStorage?.entry(forKey: "routes").object {
            return routes
        } else {
            return nil
        }
    }

    class func storeStationsMap(result: [String: Station]) {
        try? stationMapStorage?.setObject(result, forKey: "stationsMap")
    }

    class func getStationsMap() -> [String: Station]? {
        if let stationsMap = try? stationMapStorage?.entry(forKey: "stationsMap").object {
            return stationsMap
        } else {
            return nil
        }
    }

    class func storeDetailRoutes(route: DetailRoute) {
        try? detailRouteStorage?.setObject(route, forKey: "detail_route_" + route.routeID)
    }

    class func getDetailRoute(routeID: String) -> DetailRoute? {
        if let detailRoute = try? detailRouteStorage?.entry(forKey: "detail_route_" + routeID).object {
            return detailRoute
        } else {
            return nil
        }
    }

    class func getFavorite(from station: Station, to destination: Station) -> Favorite? {
        return getAllFavorites().first(where: {fav in fav.station.abbr == station.abbr && fav.destination.abbr == destination.abbr })
    }

    class func saveFavorite(from station: Station, to destination: Station) {
        var favorites = getAllFavorites()

        if !favorites.contains(where: {fav in fav.station.abbr == station.abbr && fav.destination.abbr == destination.abbr }) {
            favorites.append(Favorite(from: station, to: destination))
        }

        try? favoriteStorage?.setObject(favorites, forKey: "favorites")
    }

    class func deleteFavorite(favorite: Favorite) {
        let newFavorites = getAllFavorites().filter({ fav in fav.station.abbr != favorite.station.abbr || fav.destination.abbr != favorite.destination.abbr })

        try? favoriteStorage?.setObject(newFavorites, forKey: "favorites")
    }

    class func getAllFavorites() -> [Favorite] {
        var favorites: [Favorite] = []
        if let storedData = try? favoriteStorage?.entry(forKey: "favorites").object {
            if let storedFavorite = storedData {
                favorites = storedFavorite
            }
        }
        return favorites
    }
}
