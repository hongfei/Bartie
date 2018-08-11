//
// Created by Hongfei on 2018/8/10.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import Foundation

class DateUtil {
    static let dateFormatter = DateFormatter()
    static func getTimeDifferenceToNow(dateString: String) -> Int {
        self.dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"

        if let tripTime = self.dateFormatter.date(from: dateString) {
            return abs(Int(tripTime.timeIntervalSinceNow) / 60)
        } else {
            return 10000
        }
    }
}
