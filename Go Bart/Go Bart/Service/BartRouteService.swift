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
        getDetailRouteInfo(with: route.routeID, completionHandler: completionHandler)
    }

    static func getDetailRouteInfo(with routeID: String, completionHandler: @escaping (DetailRoute) -> Void) {
        if let detailRoute = DataCache.getDetailRoute(routeID: routeID) {
            completionHandler(detailRoute)
        } else {
            getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routeinfo", "route": String(routeID.split(separator: " ").last!)]) { response in
                guard let json = response,
                    let detailRoute = try? decoder.decode(DetailRoute.self, from: JSON(json)["root"]["routes"]["route"].rawData()) else {
                    return
                }
                
                DataCache.storeDetailRoutes(route: detailRoute)
                completionHandler(detailRoute)
            }
        }
    }

    static func getAllRoutes(completionHandler: @escaping ([Route]) -> Void) {
        if let routes = DataCache.getAllRoutes() {
            completionHandler(routes)
        } else {
            getResponse(for: ROUTE_RESOURCE, withParams: ["cmd": "routes"]) { response in
                guard let json = response, let routeArray = JSON(json)["root"]["routes"]["route"].array else {
                    return completionHandler([])
                }
                
                let routes = routeArray.map({ routeJson in try? decoder.decode(Route.self, from: routeJson.rawData()) })
                    .filter({ route in route != nil }).map({ route in route! })
                
                DataCache.storeAllRoutes(routes: routes)
                completionHandler(routes)
            }
        }
    }
}
