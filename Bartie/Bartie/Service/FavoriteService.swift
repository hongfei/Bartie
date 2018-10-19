//
// Created by Hongfei on 10/18/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class FavoriteService {
    class func getFavorite(from station: Station, to destination: Station) -> Favorite? {
        return CacheFavoriteRepository.getFavorite(from: station.abbr, to: destination.abbr)
    }

    class func saveFavorite(from station: Station, to destination: Station) {
        CacheFavoriteRepository.saveFavorite(from: station, to: destination)
    }

    class func deleteFavorite(favorite: Favorite) {
        CacheFavoriteRepository.deleteFavorite(from: favorite.station.abbr, to: favorite.destination.abbr)
    }

    class func getAllFavorites() -> [Favorite] {
        return CacheFavoriteRepository.getAllFavorites()
    }
}
