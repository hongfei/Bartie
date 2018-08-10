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
        if let detailRoute = DataCache.getDetailRoute(routeID: route.routeID) {
            completionHandler(detailRoute)
        } else {
            getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routeinfo", "route": route.number]) { response in
                if let json = response {
                    let detailRoute = try! decoder.decode(DetailRoute.self, from: JSON(json)["root"]["routes"]["route"].rawData())
                    DataCache.storeDetailRoutes(route: detailRoute)
                    completionHandler(detailRoute)
                }
            }
        }
    }

    static func getAllRoutes(completionHandler: @escaping ([Route]) -> Void) {
        if let routes = DataCache.getAllRoutes() {
            completionHandler(routes)
        } else {
            getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routes"]) { response in
                if let json = response {
                    let optionalRoutes = JSON(json)["root"]["routes"]["route"].array?.map { routeJson in
                        return try! decoder.decode(Route.self, from: routeJson.rawData())
                    }
                    if let routes = optionalRoutes {
                        DataCache.storeAllRoutes(routes: routes)
                        completionHandler(routes)
                    }
                }
            }
        }
    }
}
