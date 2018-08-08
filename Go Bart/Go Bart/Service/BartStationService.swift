//
// Created by Zhou, Hongfei on 8/7/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartStationService: BartService {
    static let STATION_RESOURCE = "/stn.aspx"

    public static func getAllStations(completionHandler: @escaping ([Station]?) -> Void) {
        getResponse(for: STATION_RESOURCE, withParams: ["cmd": "stns"]) { result in
            result.map { unwrappedResult in
                let stations = JSON(unwrappedResult)["root"]["stations"]["station"].array?.map { json in Station(with: json) }
                completionHandler(stations)
            }
        }
    }

}
