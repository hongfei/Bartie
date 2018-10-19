//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import Cache

class CacheStationRepository {
    private static let stationStorage = try? DiskStorage(config: DataCache.diskConfig, transformer: TransformerFactory.forCodable(ofType: [Station].self))
    private static let stationMapStorage = try? DiskStorage(config: DataCache.diskConfig, transformer: TransformerFactory.forCodable(ofType: [String: Station].self))

    class func storeStations(stations: [Station]) {
        let stationsMap = getStationsMap()
        var newMap = stationsMap != nil ? stationsMap! : [:]

        stations.forEach { stnt in
            newMap[stnt.abbr] = stnt
        }
        storeStationsMap(result: newMap)
    }

    class func getStations() -> [Station]? {
        guard let stationMap = getStationsMap() else {
            return []

        }

        return stationMap.values.sorted { stnt1, stnt2 in
            stnt1.abbr < stnt2.abbr
        }
    }

    class func storeStationsMap(result: [String: Station]) {
        try? stationMapStorage?.setObject(result, forKey: "stationsMap")
    }

    class func getStationsMap() -> [String: Station]? {
        guard let stationsMap = try? stationMapStorage?.entry(forKey: "stationsMap").object else {
            return nil
        }

        return stationsMap
    }

    class func getStation(with name: String) -> Station? {
        return getStationsMap()?[name]
    }
}
