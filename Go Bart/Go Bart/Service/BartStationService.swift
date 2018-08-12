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
                if let jsonResult = result {
                    let optionalStations = JSON(jsonResult)["root"]["stations"]["station"].array?.map { json in
                        return try! decoder.decode(Station.self, from: json.rawData())
                    }
                    if let stations = optionalStations {
                        DataCache.storeStations(stations: stations)
                        return completionHandler(stations)
                    }
                }

                return completionHandler([])
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
