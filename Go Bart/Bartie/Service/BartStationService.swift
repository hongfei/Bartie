//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartStationService: BartService {
    static let STATION_RESOURCE = "/stn.aspx"
    static let decoder = JSONDecoder()

    public static func getAllStations(completionHandler: @escaping ([Station]) -> Void) {
        if let stations = DataCache.getStations() {
            completionHandler(stations)
        } else {
            getResponse(for: STATION_RESOURCE, withParams: ["cmd": "stns"]) { result in
                guard let jsonResult = result, let jsonStations = JSON(jsonResult)["root"]["stations"]["station"].array else {
                    return completionHandler([])
                }
                
                let stations = jsonStations.map { json in try? decoder.decode(Station.self, from: json.rawData()) }
                    .filter { station in station != nil }.map { station in station! }
                DataCache.storeStations(stations: stations)
                completionHandler(stations)
            }
        }
    }

    public static func getAllStationMap(completionHandler: @escaping ([String: Station])-> Void) {
        if let stationsMap = DataCache.getStationsMap() {
            completionHandler(stationsMap)
        } else {
            getAllStations() { stations in
                var result: [String: Station] = [:]
                for station in stations {
                    result[station.abbr] = station
                }
                DataCache.storeStationsMap(result: result)
                completionHandler(result)
            }
        }
    }
}
