//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartStationService: BartService {
    static let STATION_RESOURCE = "/stn.aspx"

    public static func getAllStations(completionHandler: @escaping ([Station]) -> Void) {
        //TODO loading from cache first
        getResponse(for: STATION_RESOURCE, withParams: ["cmd": "stns"]) { result in
            if let jsonResult = result {
                let optionalStations = JSON(jsonResult)["root"]["stations"]["station"].array?.map { json in Station(with: json) }
                if let stations = optionalStations {
                    return completionHandler(stations)
                }
            }

            return completionHandler([])
        }
    }
}
