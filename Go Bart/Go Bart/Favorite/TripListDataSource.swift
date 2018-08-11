//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TripListDataSource:NSObject, UITableViewDataSource {
    var trips: [Trip]!

    init(trips: [Trip]) {
        self.trips = trips
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListCell", for: indexPath) as! TripListCell
        cell.setTrip(trip: trips[indexPath.row])

        return cell
    }
}
