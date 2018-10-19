//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import Cache

class CacheRouteRepository {
    private static let routeStorage = try? DiskStorage(config: DataCache.diskConfig, transformer: TransformerFactory.forCodable(ofType: [Route].self))
    private static let detailRouteStorage = try? DiskStorage(config: DataCache.diskConfig, transformer: TransformerFactory.forCodable(ofType: DetailRoute.self))

    class func storeAllRoutes(routes: [Route]) {
        try? routeStorage?.setObject(routes, forKey: "routes")
    }

    class func getAllRoutes() -> [Route]? {
        if let routes = try? routeStorage?.entry(forKey: "routes").object {
            return routes
        } else {
            return nil
        }
    }

    class func storeDetailRoutes(route: DetailRoute) {
        try? detailRouteStorage?.setObject(route, forKey: "detail_route_" + route.routeID)
    }

    class func getDetailRoute(routeID: String) -> DetailRoute? {
        if let detailRoute = try? detailRouteStorage?.entry(forKey: "detail_route_" + routeID).object {
            return detailRoute
        } else {
            return nil
        }
    }
}
