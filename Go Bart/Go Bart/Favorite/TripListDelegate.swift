//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class TripListDelegate:NSObject, UITableViewDelegate {
    var onItemSelected: ((Trip) -> Void)!

    init(onSelected: @escaping (Trip) -> Void) {
        self.onItemSelected = onSelected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TripListCell {
            onItemSelected(cell.trip)
        }
    }


}