//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class DepartureListDataSource: NSObject, UITableViewDataSource {
    var departures: [Departure]!

    init(departures: [Departure]) {
        self.departures = departures
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartureListCell", for: indexPath) as! DepartureListCell
        cell.setDeparture(departure: departures[indexPath.row])
        
        return cell
    }

}
