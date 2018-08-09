//
// Created by Zhou, Hongfei on 8/8/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit

class ScheduleListView: UITableView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = nil
        self.dataSource = nil
    }
}
