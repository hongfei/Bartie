//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import SwiftyJSON

class BartRouteRepository {
    private static let decoder = JSONDecoder()
    private static let ROUTE_RESOURCE = "/route.aspx"

    class func getDetailRouteInfo(with routeID: String, completionHandler: @escaping (DetailRoute?) -> Void) {
        BartService.getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routeinfo", "route": String(routeID.split(separator: " ").last!)]) { response in
            guard let json = response,
                  let detailRoute = try? decoder.decode(DetailRoute.self, from: JSON(json)["root"]["routes"]["route"].rawData()) else {
                return completionHandler(nil)
            }
            completionHandler(detailRoute)
        }
    }

    class func getAllRoutes(completionHandler: @escaping ([Route]) -> Void) {
        BartService.getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routes"]) { response in
            guard let json = response, let routeArray = JSON(json)["root"]["routes"]["route"].array else {
                return completionHandler([])
            }

            let routes = routeArray.map({ routeJson in try? decoder.decode(Route.self, from: routeJson.rawData()) })
                    .filter({ route in route != nil }).map({ route in route! })

            completionHandler(routes)
        }
    }
}
