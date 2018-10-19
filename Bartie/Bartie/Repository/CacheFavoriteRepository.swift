//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import Cache

class CacheFavoriteRepository {
    private static let favoriteStorage = try? DiskStorage(config: DataCache.persistentConfig, transformer: TransformerFactory.forCodable(ofType: [Favorite].self))

    class func getFavorite(from station: String, to destination: String) -> Favorite? {
        return getAllFavorites().first(where: {fav in fav.station.abbr == station && fav.destination.abbr == destination })
    }

    class func saveFavorite(from station: Station, to destination: Station) {
        var favorites = getAllFavorites()

        if !favorites.contains(where: {fav in fav.station.abbr == station.abbr && fav.destination.abbr == destination.abbr }) {
            favorites.append(Favorite(from: station, to: destination))
        }

        try? favoriteStorage?.setObject(favorites, forKey: "favorites")
    }

    class func deleteFavorite(from station: String, to destination: String) {
        let newFavorites = getAllFavorites().filter({ fav in fav.station.abbr != station || fav.destination.abbr != destination })

        try? favoriteStorage?.setObject(newFavorites, forKey: "favorites")
    }

    class func getAllFavorites() -> [Favorite] {
        var favorites: [Favorite] = []
        if let storedData = try? favoriteStorage?.entry(forKey: "favorites").object {
            if let storedFavorite = storedData {
                favorites = storedFavorite
            }
        }
        return favorites
    }
}
