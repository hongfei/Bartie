//
// Created by Hongfei on 2018/8/8.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class DepartureListDelegate: NSObject, UITableViewDelegate {
    var onItemSelected: ((Departure) -> Void)!

    init(onSelected: @escaping (Departure) -> Void) {
        self.onItemSelected = onSelected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DepartureListCell {
            onItemSelected(cell.departure)
        }
    }
}
