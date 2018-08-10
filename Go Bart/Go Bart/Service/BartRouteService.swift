//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation
import SwiftyJSON

class BartRouteService: BartService {
    private static let decoder = JSONDecoder()
    static let ROUTE_RESOURCE = "/route.aspx"

    static func getDetailRouteInfo(for route: Route,completionHandler: @escaping (DetailRoute) -> Void) {
        getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routeinfo", "route": route.number]) { response in
            if let json = response {
                let detailRoute = try! decoder.decode(DetailRoute.self, from: JSON(json)["root"]["routes"]["route"].rawData())
                completionHandler(detailRoute)
            }
        }
    }

    static func getAllRoutes(completionHandler: @escaping ([Route]) -> Void) {
        getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routes"]) { response in
            if let json = response {
                let optionalRoutes = JSON(json)["root"]["routes"]["route"].array?.map { routeJson in
                    return try! decoder.decode(Route.self, from: routeJson.rawData())
                }
                if let routes = optionalRoutes {
                    completionHandler(routes)
                }
            }
        }
    }
}
