//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class StationService: BartService {
    public static func getAllStations(completionHandler: @escaping ([Station]) -> Void) {
        if let stations = CacheStationRepository.getStations() {
            return completionHandler(stations)
        }

        BartStationRepository.getStations { stations in
            CacheStationRepository.storeStations(stations: stations)
            completionHandler(stations)
        }
    }

    public static func getAllStationMap(completionHandler: @escaping ([String: Station]) -> Void) {
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
}
