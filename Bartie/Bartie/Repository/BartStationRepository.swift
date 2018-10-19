//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BartStationRepository {
    private static let STATION_RESOURCE = "/stn.aspx"
    private static let decoder = JSONDecoder()

    class func getStations(completionHandler: @escaping ([Station]) -> Void) {
        BartService.getResponse(for: STATION_RESOURCE, withParams: ["cmd": "stns"]) { result in
            guard let jsonResult = result, let jsonStations = JSON(jsonResult)["root"]["stations"]["station"].array else {
                return completionHandler([])
            }

            let stations = jsonStations.map { json in try? decoder.decode(Station.self, from: json.rawData()) }
                    .filter { station in station != nil }.map { station in station! }
            completionHandler(stations)
        }
    }
}
