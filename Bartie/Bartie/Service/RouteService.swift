//
// Created by Hongfei on 2018/8/9.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class BartRouteService: BartService {
    static func getDetailRouteInfo(with routeID: String, completionHandler: @escaping (DetailRoute) -> Void) {
        if let detailRoute = CacheRouteRepository.getDetailRoute(routeID: routeID) {
            return completionHandler(detailRoute)
        }

        BartRouteRepository.getDetailRouteInfo(with: routeID) { detailRoute in
            if let actualDetailRoute = detailRoute {
                CacheRouteRepository.storeDetailRoutes(route: actualDetailRoute)
                return completionHandler(actualDetailRoute)
            }
        }
    }

    static func getAllRoutes(completionHandler: @escaping ([Route]) -> Void) {
        if let routes = CacheRouteRepository.getAllRoutes() {
            completionHandler(routes)
        }

        BartRouteRepository.getAllRoutes { routes in
            CacheRouteRepository.storeAllRoutes(routes: routes)
            completionHandler(routes)
        }
    }
}
